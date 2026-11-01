const express = require('express');
const router = express.Router();
const db = require('../config/database');
const auth = require('../middleware/auth');

router.use(auth);

router.get('/', async (req, res) => {
    try {
        const [rows] = await db.query(
            'SELECT * FROM siswa ORDER BY id DESC'
        );

        res.json({
            status: true,
            data: rows
        });

    } catch (error) {
        res.status(500).json({
            status: false,
            message: 'Gagal mengambil data siswa'
        });
    }
});

router.post('/', async (req, res) => {
    try {
        const {
            nipd,
            nama_lengkap,
            jenis_kelamin,
            alamat,
            kelas,
            jurusan
        } = req.body;

        if (!nipd || !nama_lengkap || !jenis_kelamin || !kelas || !jurusan) {
            return res.status(400).json({
                status: false,
                message: 'Data wajib harus diisi'
            });
        }

        const [result] = await db.query(
            `INSERT INTO siswa
            (nipd, nama_lengkap, jenis_kelamin, alamat, kelas, jurusan)
            VALUES (?, ?, ?, ?, ?, ?)`,
            [nipd, nama_lengkap, jenis_kelamin, alamat, kelas, jurusan]
        );

        res.status(201).json({
            status: true,
            message: 'Data siswa berhasil ditambahkan',
            id: result.insertId
        });

    } catch (error) {
        res.status(500).json({
            status: false,
            message: 'Gagal menambahkan data siswa'
        });
    }
});

router.put('/:id', async (req, res) => {
    try {
        const {
            nipd,
            nama_lengkap,
            jenis_kelamin,
            alamat,
            kelas,
            jurusan
        } = req.body;

        const { id } = req.params;

        await db.query(
            `UPDATE siswa SET
            nipd = ?,
            nama_lengkap = ?,
            jenis_kelamin = ?,
            alamat = ?,
            kelas = ?,
            jurusan = ?
            WHERE id = ?`,
            [nipd, nama_lengkap, jenis_kelamin, alamat, kelas, jurusan, id]
        );

        res.json({
            status: true,
            message: 'Data siswa berhasil diperbarui'
        });

    } catch (error) {
        res.status(500).json({
            status: false,
            message: 'Gagal memperbarui data siswa'
        });
    }
});

router.delete('/:id', async (req, res) => {
    try {
        const { id } = req.params;

        const [result] = await db.query(
            'DELETE FROM siswa WHERE id = ?',
            [id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({
                status: false,
                message: 'Data siswa tidak ditemukan'
            });
        }

        res.json({
            status: true,
            message: 'Data siswa berhasil dihapus'
        });

    } catch (error) {
        res.status(500).json({
            status: false,
            message: 'Gagal menghapus data siswa'
        });
    }
});

module.exports = router;