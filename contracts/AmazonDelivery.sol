pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract AmazonDelivery{
    address payable contractOwner;
    uint orderID = 0;
    uint productID = 0;
    uint userID = 0;
    uint[] orderIDList;


    //OwnerType enum
    enum OwnerType{
        Factory,
        Delivery,
        Customer
    }

    // Physical Readings struct
    struct PhysicalReadings{
        uint accelerometerX;  //accelerometerPitch
        uint accelerometerY;  //accelerometerRoll
        uint accelerometerZ;  //accelerometerAzimuth
    }

    // Struct to store product history
    struct ProductHistory{
        uint oid;
        OrderDetails orderDetails;
        PhysicalReadings physicalReadings;
        uint transferredOnBackend;
        uint transactionTime;
        bool validQuality;
        address payable currentOwner;
        bool refundStatus;
        OwnerType ownerType;
    }

    // Order Details struct
    struct OrderDetails{
        uint oid;
        string boxHash;
        uint productId;
        string orderProductName;
        uint orderValue;
        address customerAddress;
    }

    mapping(uint => ProductHistory[]) public history;

    event transferOwnership(uint _orderID, address payable _transferredTo);
    event PlacedOrder(uint _orderID, uint _productID, address _customerAddress, uint _orderValue);

    constructor() public {
        contractOwner = payable(msg.sender);
    }

    function getOrderID() public view returns(uint){
        return orderID;
    }

    function placeOrder(uint _productID, string memory _productName, uint _orderValue, string memory _boxHash, uint _accelerometerX, uint _accelerometerY, uint _accelerometerZ, uint _transferredOnBackend) public payable{
        require(msg.value == _orderValue, "Amount Paid is not correct");
        orderID= orderID + 1;
        emit PlacedOrder(orderID, _productID, msg.sender, _orderValue);
        ProductHistory memory _productHistory;
        PhysicalReadings memory _physicalReadings = getPhysicalReadings(_accelerometerX, _accelerometerY, _accelerometerZ);
        OrderDetails memory _orderDetails = getOrderDetails(orderID, _productID, _productName, _orderValue, msg.sender, _boxHash);
        _productHistory.physicalReadings = _physicalReadings;
        _productHistory.orderDetails = _orderDetails;
        _productHistory.oid = orderID;
        _productHistory = insertFirstEntry(_productHistory, _transferredOnBackend);
        history[orderID].push(_productHistory);
    }

    function getOrderDetails(uint _orderID, uint _productID, string memory _productName, uint _orderValue, address _customerAddress, string memory _boxHash) internal view returns( OrderDetails memory){

        OrderDetails memory _orderDetails = OrderDetails({
            oid: _orderID,
            customerAddress: _customerAddress,
            productId: _productID,
            orderProductName: _productName,
            orderValue : _orderValue,
            boxHash: _boxHash
        });
        return _orderDetails;
    }

    function getPhysicalReadings(uint _accelerometerX, uint _accelerometerY, uint _accelerometerZ) public view returns(PhysicalReadings memory){
        PhysicalReadings memory _physicalReadings = PhysicalReadings({
            accelerometerX: _accelerometerX,
            accelerometerY: _accelerometerY,
            accelerometerZ: _accelerometerZ
        });
        return _physicalReadings;
    }

    function insertFirstEntry(ProductHistory memory _productHistory, uint _transferredOnBackend) internal returns(ProductHistory memory){
        _productHistory.transferredOnBackend= _transferredOnBackend;
        _productHistory.transactionTime= block.timestamp;
        _productHistory.currentOwner= payable(contractOwner);
        _productHistory.refundStatus= false;
        _productHistory.ownerType = OwnerType.Factory;
        return _productHistory;
    }

    function transferOrder(uint _orderID, address payable _transferredTo, uint _accelerometerX, uint _accelerometerY, uint _accelerometerZ) public {
        ProductHistory memory _product = history[_orderID][history[_orderID].length-1];
        require(_product.currentOwner == payable(msg.sender), "Current owner nor carrying out transaction");
//        require(_product.validQuality);
        _product.currentOwner = _transferredTo;
        _product.transferredOnBackend = block.timestamp;
        _product.transactionTime= block.timestamp;
        (_transferredTo == _product.orderDetails.customerAddress) ? _product.ownerType = OwnerType.Customer : _product.ownerType = OwnerType.Delivery;
        history[_orderID].push(_product);
        emit transferOwnership(_orderID, _transferredTo);
    }

    //get order status
    function getOrderStatus(uint _orderID) public view returns(ProductHistory[] memory){
        return history[_orderID];
    }


    // Only final Customer can view and match the box hash
    function getBoxDetails(uint _orderID) public view returns(string memory){
        require(msg.sender == history[_orderID][0].orderDetails.customerAddress, "Not the final customer");
        return history[_orderID][0].orderDetails.boxHash;
    }

//    //when refund request is generated.. seller need to verify
//    function getBoxDetails(uint _orderID) public view returns(string memory){
//        require(msg.sender == history[_orderID][0].orderDetails.customerAddress, "Not the final customer");
//        return history[_orderID][0].orderDetails.boxHash;
//    }

    function approveRefund(uint _orderID) public {
        require(msg.sender==contractOwner, "Access to refund denied");
        ProductHistory memory productHistory;
        productHistory= history[_orderID][history[_orderID].length-1];
        productHistory.refundStatus= true;
        refundAmount(_orderID, productHistory.orderDetails.orderValue);
        history[_orderID].push(productHistory);
    }


//    Refund amount to the customer for returned
    function refundAmount(uint _orderID, uint amount) internal {
        require(msg.sender==contractOwner, "Access to refund denied");
        history[_orderID][history[_orderID].length-1].currentOwner.transfer(history[_orderID][0].orderDetails.orderValue);
    }
}

//    function getQualityStatus(uint _orderID) public view returns(bool){
//        return history[_orderID][history[_orderID].length-1].validQuality;
//    }



//    function qualityEntry(uint _orderID, uint _accelerometerX, uint _accelerometerY, uint _accelerometerZ, uint _transferredOnBackend) public {
//        //Check if no order done
//        require(_orderID!=0);
//        ProductHistory memory product = history[_orderID][history[_orderID].length-1];
////        bool validQualityV = validQuality(_orderID, temperature, humidity, product.physicalReadings.humidityThresholdHigh, product.physicalReadings.humidityThresholdHigh, product.physicalReadings.temperatureThresholdLow, product.physicalReadings.humidityThresholdLow);
////        require(product.validQuality);
//
//        product.transferredOnBackend = _transferredOnBackend;
//        product.transactionTime= block.timestamp;
////        product.validQuality = validQualityV;
//        product.validQuality = true;
//        history[_orderID].push(product);
//    }

//    function validQuality( uint _orderID, uint temperature, uint humidity, uint temperatureThresholdHigh, uint humidityThresholdHigh, uint temperatureThresholdLow, uint humidityThresholdLow) internal view returns(bool) {
//        ProductHistory memory product = history[_orderID][history[_orderID].length-1];
//        if((product.validQuality) && (temperature <= temperatureThresholdHigh) && (temperature >= temperatureThresholdLow) && (humidity >= humidityThresholdLow) && (humidity <= humidityThresholdHigh))
//            return true;
//        return false;
//    }
