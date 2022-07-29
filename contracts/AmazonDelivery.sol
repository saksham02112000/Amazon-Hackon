pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract AmazonDelivery{
    address contractOwner;
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
        uint gyroscopeX;
        uint gyroscopeY;
        uint gyroscopeZ;
    }

    // Struct to store product history
    struct ProductHistory{
        uint oid;
        OrderDetails orderDetails;
        PhysicalReadings physicalReadings;
        uint transferredOnBackend;
        uint transactionTime;
        bool validQuality;
        address currentOwner;
        bool refundStatus;
        OwnerType ownerType;
    }

    // Order Details struct
    struct OrderDetails{
        uint oid;
        uint productId;
        uint productName;
        uint orderValue;
        address customerAddress;
    }


    // User struct
    struct Users{
        uint uID;
        string name;
        string email;
    }

    mapping(uint => ProductHistory[]) public history;
    mapping(address => OrderDetails[]) public userOrderHistory;
    mapping(address => Users) public users;
    mapping(uint => string) public productName;

    // modifier to check if user is registered or not
    modifier registeredUserModifier(address userAddress){
        require(
            users[userAddress].uID>0,
            "User not registered."
        );
        _;
    }

    // check if user is not registered
    modifier unRegisteredUserModifier(address userAddress){
        require(
            !(users[userAddress].uID>0),
            "User not registered."
        );
        _;
    }

    constructor() public {
        contractOwner = msg.sender;
    }

    function getUserDetails() public view returns(Users memory){
        //check at frontend name should not be empty
        return users[msg.sender];
    }

    function getOrderID() public view returns(uint){
        console.log(orderID);
        return orderID;
    }

    function registerProduct(string memory _productName) public {
        productID = productID + 1;
        productName[productID] = _productName;
    }

    function placeOrder(uint _orderID, uint _productID, uint _productName, uint _orderValue, address _customerAddress,uint _accelerometerX, uint _accelerometerY, uint _accelerometerZ, uint _gyroscopeX, uint _gyroscopeY, uint _gyroscopeZ) public registeredUserModifier(msg.sender) returns(uint){
        orderID= orderID + 1;
        ProductHistory memory _productHistory;
        PhysicalReadings memory _physicalReadings = getPhysicalReadings(_accelerometerX, _accelerometerY, _accelerometerZ, _gyroscopeX, _gyroscopeY, _gyroscopeZ);
        OrderDetails memory _orderDetails = getOrderDetails(_orderID, _productID, _productName, _orderValue, _customerAddress);
        _productHistory = insertID(_productHistory, _productID);
        _productHistory = insertDescriptionAndTimestamp(_productHistory, _description);
        _productHistory.physicalReadings = _physicalReadings;
        _productHistory =insertGPSCoordinates(_productHistory, _latitude, _longitude);
        history[orderID].push(_productHistory);
        return orderID;
    }

    function getOrderDetails(uint _orderID, uint _productID, uint _productName, uint _orderValue, address _customerAddress) internal view returns( OrderDetails memory){

        OrderDetails memory _orderDetails = OrderDetails({
            oid: _orderID,
            customerAddress: _customerAddress,
            productId: _productID,
            productName: _productName,
            orderValue : _orderValue
        });
        return _orderDetails;
    }

    function insertPhysicalReadings(uint _accelerometerX, uint _accelerometerY, uint _accelerometerZ, uint _gyroscopeX, uint _gyroscopeY, uint _gyroscopeZ) public view returns(PhysicalReadings memory){
        PhysicalReadings memory _physicalReadings = PhysicalReadings({
            accelerometerX: _accelerometerX,
            accelerometerY: _accelerometerY,
            accelerometerZ: _accelerometerZ,
            gyroscopeX: _gyroscopeX,
            gyroscopeY : _gyroscopeY,
            gyroscopeZ : _gyroscopeZ
        });
        return _physicalReadings;
    }

    function insertDescriptionAndTimestamp(ProductHistory memory _productHistory, string memory _description) internal returns(ProductHistory memory){
        _productHistory.description= _description;
        _productHistory.transferredOn= block.timestamp;
        _productHistory.transactionTime= block.timestamp;
        return _productHistory;
    }

    function getPhysicalReadings( uint _temperatureThresholdHigh, uint _humidityThresholdHigh, uint _temperatureThresholdLow, uint _humidityThresholdLow, uint _temperature, uint _humidity) internal pure returns(PhysicalReadings memory){
        PhysicalReadings memory _physicalReadings = PhysicalReadings({
            temperatureThresholdHigh: _temperatureThresholdHigh,
            humidityThresholdHigh: _humidityThresholdHigh,
            temperatureThresholdLow: _temperatureThresholdLow,
            humidityThresholdLow: _humidityThresholdLow,
            temperature : _temperature,
            humidity : _humidity
        });
        return _physicalReadings;
    }

    function registerUser(string memory _name, string memory _email) public returns(uint){
        //        require(_name!= "", "Name should not be Blank");
        //        require(_email!="",  "Email should not be Blank");
        userID = userID + 1 ;
        Users memory userData= Users({
        uID: userID,
        name: _name,
        email: _email
        });
        users[msg.sender] = userData;
        return userID;
    }

    function transferOrder(uint orderIDV, address transferredTo, uint latitude, uint longitude, uint temperature, uint humidity, string memory description) public returns(uint){
        ProductHistory memory product = history[orderIDV][history[orderIDV].length-1];
        require(product.ownerAddress == msg.sender);
        require(product.validQuality);
        product.transferredOn = block.timestamp;
        product.ownerAddress = transferredTo;
        product.transactionTime= block.timestamp;
        product.description = description;
        product.level = product.level + 1;
        history[orderIDV].push(product);
        return orderIDV;
    }

    function qualityEntry(uint orderIDV, uint latitude, uint longitude, uint temperature, uint humidity) public {
        //Check if no order done
        require(orderIDV!=0);
        ProductHistory memory product = history[orderIDV][history[orderIDV].length-1];
        bool validQualityV = validQuality(orderIDV, temperature, humidity, product.physicalReadings.humidityThresholdHigh, product.physicalReadings.humidityThresholdHigh, product.physicalReadings.temperatureThresholdLow, product.physicalReadings.humidityThresholdLow);
        require(product.validQuality);
        product.latitude = latitude;
        product.longitude = longitude;
        product.physicalReadings.temperature = temperature;
        product.physicalReadings.humidity = humidity;
        product.transactionTime= block.timestamp;
        product.validQuality = validQualityV;
        history[orderIDV].push(product);
    }

    function getOrderStatus(uint orderIDV) public view returns(ProductHistory[] memory){
        return history[orderIDV];
    }


    function getQualityStatus(uint orderIDV) public view returns(bool){
        return history[orderIDV][history[orderIDV].length-1].validQuality;
    }

    function validQuality( uint orderIDV, uint temperature, uint humidity, uint temperatureThresholdHigh, uint humidityThresholdHigh, uint temperatureThresholdLow, uint humidityThresholdLow) internal view returns(bool) {
        ProductHistory memory product = history[orderIDV][history[orderIDV].length-1];
        if((product.validQuality) && (temperature <= temperatureThresholdHigh) && (temperature >= temperatureThresholdLow) && (humidity >= humidityThresholdLow) && (humidity <= humidityThresholdHigh))
            return true;
        return false;
    }


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
//        require(msg.sender==contractOwner, "Access to refund denied");
        history[_orderID].currentOwner.transfer(history[_orderID][0].orderDetails.customerAddress);
    }

}