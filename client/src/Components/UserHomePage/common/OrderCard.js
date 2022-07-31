import * as React from 'react';
import Card from '@mui/material/Card';
import CardActions from '@mui/material/CardActions';
import CardContent from '@mui/material/CardContent';
import CardMedia from '@mui/material/CardMedia';
import Button from '@mui/material/Button';
import Typography from '@mui/material/Typography';
import CurrencyRupeeIcon from '@mui/icons-material/CurrencyRupee';
import ProductionQuantityLimitsIcon from '@mui/icons-material/ProductionQuantityLimits';
import Backdrop from '@mui/material/Backdrop';
import Box from '@mui/material/Box';
import Modal from '@mui/material/Modal';
import Fade from '@mui/material/Fade';
import { ethers } from 'ethers';
export default function OrderCard({ item }) {
    const [open, setOpen] = React.useState(false);
    const handleOpen = () => setOpen(true);
    const handleClose = () => setOpen(false);
    // const [orderHistory, setOrderHistory] = useState([{
    //     "oid": 0,
    //     "orderDetails": {
    //         "oid": 0,
    //         "boxHash": "",
    //         "productId": 0,
    //         "orderProductName": "",
    //         "orderValue": -1,
    //         "customerAddress": ""
    //     },
    //     "physicalReadings": {
    //         "accelerometerX": 0,
    //         "accelerometerY": 0,
    //         "accelerometerZ": 0
    //     },
    //     "transferredOnBackend": -1,
    //     "transactionTime": -1,
    //     "validQuality": true,
    //     "currentOwner": "",
    //     "refundStatus": true,
    //     "ownerType": -1
    // }]);
    // const getOrderDetails = async () => {
    //     // const provider = new ethers.providers.Web3Provider(window.ethereum);
    //     const provider = new ethers.providers.JsonRpcProvider("http://localhost:8545");
    //     const signer = provider.getSigner();
    //     // const contract = new ethers.Contract(contractAddress, SupplyChain.abi, signer);
    //     const contract = new ethers.Contract(contractAddress, SupplyChain.abi, provider);

    //     try {
    //         const orderHistoryDetails = await contract.getOrderStatus(item.orderId);
    //         const setValOrderHistory = () => {
    //             let returnVal = [];
    //             for (let i = 0; i < orderHistoryDetails.length; i++) {
    //                 const itrValue = {
    //                     oid: orderHistoryDetails[i].oid.toNumber(),
    //                     orderDetails: {
    //                         oid: orderHistoryDetails[i].orderDetails.oid.toNumber(),
    //                         boxHash: orderHistoryDetails[i].orderDetails.boxHash,
    //                         productId: orderHistoryDetails[i].orderDetails.productId.toNumber(),
    //                         orderProductName: orderHistoryDetails[i].orderDetails.orderProductName,
    //                         orderValue: orderHistoryDetails[i].orderDetails.orderValue.toNumber(),
    //                         customerAddress: orderHistoryDetails[i].orderDetails.customerAddress
    //                     },
    //                     physicalReadings: {
    //                         accelerometerX: orderHistoryDetails[i].physicalReadings.accelerometerX.toNumber(),
    //                         accelerometerY: orderHistoryDetails[i].physicalReadings.accelerometerY.toNumber(),
    //                         accelerometerZ: orderHistoryDetails[i].physicalReadings.accelerometerZ.toNumber(),
    //                     },
    //                     transferredOnBackend: orderHistoryDetails[i].transferredOnBackend,
    //                     transactionTime: orderHistoryDetails[i].transactionTime.toNumber(),
    //                     validQuality: orderHistoryDetails[i].validQuality,
    //                     currentOwner: orderHistoryDetails[i].currentOwner,
    //                     refundStatus: orderHistoryDetails[i].refundStatus,
    //                     ownerType: orderHistoryDetails[i].ownerType
    //                 }
    //                 returnVal.push(itrValue);
    //             }
    //             return returnVal;
    //         }
    //         setOrderHistory(setValOrderHistory);
    //     }

    //     catch (err) {
    //         setErrorSnackbarMessage(err.message);
    //         handleClickError();
    //     }
    // }
    const style = {
        position: 'absolute',
        top: '50%',
        left: '50%',
        transform: 'translate(-50%, -50%)',
        width: '70%',
        height: "60%",
        bgcolor: 'background.paper',
        border: '1px solid grey',
        boxShadow: 24,
        p: 4,
        borderRadius: "12px"
    };

    return (
        <Card sx={{ maxWidth: 345 }}>

            <CardMedia
                component="img"
                alt="green iguana"
                height="140"
                image={`${process.env.REACT_APP_BASE_URL}` + `${item.itemId.image_link}`}
            />
            <CardContent>
                <Typography gutterBottom variant="h5" component="div" style={{ display: "flex", justifyContent: "space-between", alignContent: "center" }}>
                    <span style={{ color: "black" }}>{item.itemId.name}</span>
                    {/* <span style={{ color: "black", display: "flex", justifyContent: "space-between", alignContent: "center" }} ><ProductionQuantityLimitsIcon style={{ color: "grey" }} /> {item.quantity}</span> */}
                    <span style={{ color: "black", display: "flex", justifyContent: "space-between", alignContent: "center" }} ><CurrencyRupeeIcon style={{ color: "grey" }} /> {item.itemId.price}</span>

                </Typography>
                <Typography variant="body2" color="text.secondary">
                    {item.itemId.description}
                </Typography>
            </CardContent>
            <CardActions>
                <Button variant="contained" onClick={handleOpen} size="small">View Details</Button>
                {/* <Button size="small">Learn More</Button> */}
            </CardActions>
            <Modal
                disableAutoFocus
                aria-labelledby="transition-modal-title"
                aria-describedby="transition-modal-description"
                open={open}
                onClose={handleClose}
                closeAfterTransition
                BackdropComponent={Backdrop}
                BackdropProps={{
                    timeout: 500,
                }}
            >
                <Fade in={open}>
                    <Box sx={style}>
                        <Typography id="transition-modal-title" variant="h6" component="h2">
                            Text in a modal
                        </Typography>
                        <Typography id="transition-modal-description" sx={{ mt: 2 }}>
                            Duis mollis, est non commodo luctus, nisi erat porttitor ligula.
                        </Typography>
                    </Box>
                </Fade>
            </Modal>
        </Card >
    );
}