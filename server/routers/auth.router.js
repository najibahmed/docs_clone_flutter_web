const express = require('express');
const auth = require('../middlewares/auth');
const router = express.Router();
const AuthController= require('../controllers/auth.controller');
const authController= new AuthController();

router.post('/register', authController.RegisterUser);
router.get('/login',auth, authController.GetUser);

module.exports= router;