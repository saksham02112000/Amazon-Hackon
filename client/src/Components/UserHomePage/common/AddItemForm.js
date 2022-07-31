import React from 'react';
import { Button, TextField } from '@mui/material';
export default function AddItemForm() {
    return (
        <div>
            <h1>Add New Item</h1>
            <TextField style={{ width: "500px" }} required label="Name" variant="outlined" type="text" className="productName" /><br /><br />
            <TextField style={{ width: "500px" }} required label="Description" variant="outlined" type="text" className="productDescription" /><br /><br />
            <TextField style={{ width: "500px" }} required label="Price" variant="outlined" type="number" className="productPrice" /><br /><br />
            <TextField style={{ width: "500px" }} required label="Quantity" variant="outlined" type="number" className="productQuantity" /><br /><br />
            <TextField style={{ width: "500px" }} required variant="outlined" type="file" className="productImage" /><br /><br />
            <Button variant="contained" style={{ backgroundColor: "green" }} size="large" >Add Item</Button>
        </div>
    );
}