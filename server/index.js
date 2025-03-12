const express = require('express');
const mongoose = require('mongoose');
const app = express();
const cors = require('cors');
app.use(cors());
app.use(express.json());
require('dotenv').config();
 const authRouter=require('./routers/auth.router');


app.use("/api/auth",authRouter);






const DB = process.env.MONGO_CONNECTION_STRING;
const PORT = process.env.PORT || 3001;
mongoose.connect(DB).then(() => {
    console.log('Connected to MongoDB');
    app.listen(PORT, "0.0.0.0", () => {
        console.log(`Server listening on port ${PORT}`);
    });
}).catch(err => {
    console.log('Error: ', err.message);
});


