import * as React from 'react';
import Card from '@mui/material/Card';
import CardActions from '@mui/material/CardActions';
import CardContent from '@mui/material/CardContent';
import CardMedia from '@mui/material/CardMedia';
import Button from '@mui/material/Button';
import Typography from '@mui/material/Typography';
import CurrencyRupeeIcon from '@mui/icons-material/CurrencyRupee';
import ProductionQuantityLimitsIcon from '@mui/icons-material/ProductionQuantityLimits';
export default function ItemCard({ item }) {
    return (
        <Card sx={{ maxWidth: 345 }}>
            <CardMedia
                component="img"
                alt="green iguana"
                height="140"
                image={`${process.env.REACT_APP_BASE_URL}` + `${item.image_link}`}
            />
            <CardContent>
                <Typography gutterBottom variant="h5" component="div" style={{ display: "flex", justifyContent: "space-between", alignContent: "center" }}>
                    <span style={{ color: "black" }}>{item.name}</span>
                    <span style={{ color: "black", display: "flex", justifyContent: "space-between", alignContent: "center" }} ><ProductionQuantityLimitsIcon style={{ color: "grey" }} /> {item.quantity}</span>
                    <span style={{ color: "black", display: "flex", justifyContent: "space-between", alignContent: "center" }} ><CurrencyRupeeIcon style={{ color: "grey" }} /> {item.price}</span>

                </Typography>
                <Typography variant="body2" color="text.secondary">
                    {item.description}
                </Typography>
            </CardContent>
            <CardActions>
                <Button variant="contained" size="small">Buy Now</Button>
                {/* <Button size="small">Learn More</Button> */}
            </CardActions>
        </Card >
    );
}