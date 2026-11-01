const express = require('express');
const router = express.Router();
const db = require('../config/database');
const auth = require('../middleware/auth');
const bcrypt = require('bcryptjs');

router.use(auth);

router.get('/', async (req, res) => {
    try {
        const [rows] = await db.query(
            'SELECT id, nama, email FROM users ORDER BY id DESC'
        );

        res.json({
            status: true,
            data: rows
        });

    } catch (error) {
        res.status(500).json({
            status: false,
            message: 'Gagal mengambil data user'
        });
    }
});

router.post('/', async (req, res) => {
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
            message: 'Data user berhasil ditambahkan',
            id: result.insertId
        });

    } catch (error) {
        res.status(500).json({
            status: false,
            message: 'Gagal menambahkan data user'
        });
    }
});

router.put('/:id', async (req, res) => {
    try {
        const { nama, email, password } = req.body;
        const { id } = req.params;

        if (!nama || !email) {
            return res.status(400).json({
                status: false,
                message: 'Nama dan email harus diisi'
            });
        }

        if (password) {
            const hashedPassword = await bcrypt.hash(password, 10);

            await db.query(
                'UPDATE users SET nama = ?, email = ?, password = ? WHERE id = ?',
                [nama, email, hashedPassword, id]
            );
        } else {
            await db.query(
                'UPDATE users SET nama = ?, email = ? WHERE id = ?',
                [nama, email, id]
            );
        }

        res.json({
            status: true,
            message: 'Data user berhasil diperbarui'
        });

    } catch (error) {
        res.status(500).json({
            status: false,
            message: 'Gagal memperbarui data user'
        });
    }
});

router.delete('/:id', async (req, res) => {
    try {
        const { id } = req.params;

        const [result] = await db.query(
            'DELETE FROM users WHERE id = ?',
            [id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({
                status: false,
                message: 'Data user tidak ditemukan'
            });
        }

        res.json({
            status: true,
            message: 'Data user berhasil dihapus'
        });

    } catch (error) {
        res.status(500).json({
            status: false,
            message: 'Gagal menghapus data user'
        });
    }
});

module.exports = router;