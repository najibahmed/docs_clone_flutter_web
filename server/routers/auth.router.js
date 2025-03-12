const express = require('express');
const router = express.Router();
const AuthController= require('../controllers/auth.controller');
const authController= new AuthController();

router.post('/register', authController.RegisterUser);
router.get('/user', (req, res) => {
    res.send('Najib Ahmed');
});

module.exports= router;