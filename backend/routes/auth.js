const express = require('express');
const router = express.Router();
const db = require('../config/database');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

router.post('/register', async (req, res) => {
    try {
        const { nama, email, password } = req.body;

        if (!nama || !email || !password) {
            return res.status(400).json({
                status: false,
                message: 'Semua data harus diisi'
            });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const [result] = await db.query(
            'INSERT INTO users (nama, email, password) VALUES (?, ?, ?)',
            [nama, email, hashedPassword]
        );

        res.status(201).json({
            status: true,
            message: 'Registrasi berhasil',
            data: {
                id: result.insertId,
                nama,
                email
            }
        });

    } catch (error) {
        res.status(500).json({
            status: false,
            message: 'Registrasi gagal'
        });
    }
});

router.post('/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        const [rows] = await db.query(
            'SELECT * FROM users WHERE email = ?',
            [email]
        );

        if (rows.length === 0) {
            return res.status(401).json({
                status: false,
                message: 'Email tidak ditemukan'
            });
        }

        const user = rows[0];

        const cocok = await bcrypt.compare(
            password,
            user.password
        );

        if (!cocok) {
            return res.status(401).json({
                status: false,
                message: 'Password salah'
            });
        }

        const token = jwt.sign(
            {
                id: user.id,
                email: user.email
            },
            process.env.JWT_SECRET,
            {
                expiresIn: '1d'
            }
        );

        res.json({
            status: true,
            message: 'Login berhasil',
            data: {
                token,
                user: {
                    id: user.id,
                    nama: user.nama,
                    email: user.email
                }
            }
        });

    } catch (error) {
        res.status(500).json({
            status: false,
            message: 'Terjadi kesalahan pada server'
        });
    }
});

module.exports = router;