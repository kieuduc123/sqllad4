/*Tạo database lab3 và kết nối tới database*/
GO

CREATE DATABASE lab3;

USE lab3;

GO
DROP DATABASE lab3;

/*Tạo bảng phòng ban*/
CREATE TABLE phongban (
 MaPB varchar(7)PRIMARY KEY  not null,
 TenPB nvarchar(50) not null
);
/* Xóa bảng*/
ROP TABLE phongban;

GO

/*Tạo bảng nhân viên*/
CREATE TABLE nhanvien  (
 MaNV varchar(7)PRIMARY KEY not null,
 TenNV nvarchar(50) not null,
 NgaySinh datetime not null check ( NgaySinh <(getdate())),
 SoCMND char(9) not null check( ISNUMERIC(SoCMND) = 1) ,
 GioiTinh char(1) not null DEFAULT 'M',
 DiaChi nvarchar(100) not null,
 NgayVaoLam datetime not null ,
 MaPB varchar(7)
 FOREIGN KEY (MaPB) REFERENCES phongban(MaPB),
 check (DATEDIFF(year, NgayVaoLam, NgaySinh) <= -20)
);
/* Xóa bảng*/
DROP TABLE nhanvien;

GO
/*Tạo bảng LUONGDA*/
CREATE TABLE luongDA  (
 MaDA varchar(8) null,
 MaNV varchar(7)PRIMARY KEY not null,
 NgayNhan Datetime not null default (getdate()),
 SoTien money not null check (SoTien > 0),
 FOREIGN KEY (MaNV) REFERENCES nhanvien(MaNV)
);
/* Xóa bảng*/
DROP TABLE luongDA;

/* 1.Thực hiện chèn dữ liệu vào các bảng vừa tạo (ít nhất 5 bản ghi cho mỗi bảng).*/

insert phongban (MaPB,TenPB)       
values ('0000001',N'Kế Toán'),('0000002',N'Nhân Sự'), ('0000003',N'Kinh Doanh'),
  ('0000004',N'Dự Án'),('0000005',N'Đầu Tư');
select * from phongban
where DATEDIFF(year, '2012-09-03', '1980-09-03') <= -20

insert nhanvien (MaNV, TenNV, NgaySinh,SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB)       
values ('1',N'NGUYỄN KHÁNH LY','1980-09-03','123456789','M',N'HÀ NỘI','2012-09-03','0000001'),
  ('2',N'NGUYỄN ĐÀO GIẾNG','1980-09-03','112345679','F',N'HÀ NỘI','2012-09-03','0000002'),
  ('3',N'NGUYỄN ĐỨC ANH','1980-09-03','123456898','F',N'HƯNG YÊN','2012-09-03','0000003'),
  ('4',N'TRẦN MINH ĐỨC','1980-09-03','435678932','M',N'QUẢNG NINH','2012-09-03','0000004'),
  ('5',N'NGUYỄN HOÀNG THÙY LINH','1980-09-03','097456434','F',N'CÀ MAU','2012-09-03','0000005'),
  ('6',N'TRẦN QUỐC OAI','1980-12-12','345231657','M',N'NHA TRANG','2012-09-03','0000001'),
  ('7',N'VŨ SONG VŨ','1980-12-12','234561267','M',N'HÀ NỘI','2012-09-03','0000002');
delete luongDA
delete nhanvien
insert luongDA (MaDA ,MaNV,SoTien)      
values ('da01','1',900000000),
  ('da02','2',900000000),
  ('da03','3',900000000),
  ('da04','4',900000000),
  ('da05','5',900000000),
  ('da06','6',900000000),
  ('da07','7',900000000);

/* 2. Viết một query để hiển thị thông tin về các bảng LUONGDA, NHANVIEN, PHONGBAN.*/

SELECT * FROM phongban;
SELECT * FROM nhanvien;
SELECT * FROM luongDA;

/* 3. Viết một query để hiển thị những nhân viên có giới tính là ‘F’.*/

SELECT * FROM nhanvien WHERE GioiTinh='F';

/* 4. Hiển thị tất cả các dự án, mỗi dự án trên 1 dòng*/

SELECT MaDA AS'Full DA' from luongDA; 

/* 5. Hiển thị tổng lương của từng nhân viên (dùng mệnh đề GROUP BY).*/

SELECT MaNV, SUM(SoTien) FROM luongDA GROUP BY MaNV;

/* 6. Hiển thị tất cả các nhân viên trên một phòng ban cho trước (VD: ‘Hành chính’).*/

SELECT * FROM nhanvien WHERE MaPB='0000005';

/* 7. Hiển thị mức lương của những nhân viên phòng hành chính.*/

/* 7.1. Hiển thị nhân viên phòng hành chính*/
CREATE VIEW nhanvienhanhchinh AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB FROM  nhanvien 
WHERE MaPB='0000005'
WITH CHECK OPTION;

/* 7.2. Lấy ra danh sách nhân viên phòng hành chính*/
select * from nhanvienhanhchinh;

/* 7.3. Hiển thị mức lương của những nhân viên phòng hành chính*/
CREATE VIEW luongnhanvienhanhchinh AS
SELECT  TenNV, SoTien, GioiTinh
     FROM nhanvienhanhchinh
     INNER JOIN luongDA
     ON nhanvienhanhchinh.MaNV = luongDA.MaNV;
/*Hiển thị*/
SELECT * FROM luongnhanvienhanhchinh;

/* 8. Hiển thị số lượng nhân viên của từng phòng.*/

/* 8.1. thông tin chi tiết tất cả nhân viên của từng phòng */
CREATE VIEW nhanvienketoan AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB
 FROM  nhanvien
 WHERE MaPB='0000001'
 WITH CHECK OPTION;

SELECT * FROM nhanvienketoan;

CREATE VIEW nhanviennhansu AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB
 FROM  nhanvien
 WHERE MaPB='0000002'
 WITH CHECK OPTION;

SELECT * FROM nhanviennhansu;

CREATE VIEW nhanvienkinhdoanh AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB
 FROM  nhanvien
 WHERE MaPB='0000003'
 WITH CHECK OPTION;

SELECT * FROM nhanvienkinhdoanh;

CREATE VIEW nhanvienthietke AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB
 FROM  nhanvien
 WHERE MaPB='0000004'
 WITH CHECK OPTION;

SELECT * FROM nhanvienthietke;

CREATE VIEW nhanvienhanhchinh AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB
 FROM  nhanvien
 WHERE MaPB='0000005'
 WITH CHECK OPTION;

SELECT * FROM nhanvienhanhchinh;

/* 8.2. Hiển thị số lượng nhân viên của từng phòng*/
SELECT COUNT(*) AS N'Nhân viên kế toán' FROM nhanvienketoan ;
SELECT COUNT(*) AS N'Nhân viên nhân sự' FROM nhanviennhansu ;
SELECT COUNT(*) AS N'Nhân viên kinh doanh' FROM nhanvienkinhdoanh ;
SELECT COUNT(*) AS N'Nhân viên thiết kế' FROM nhanvienthietke ;
SELECT COUNT(*) AS N'Nhân viên hành chính' FROM nhanvienhanhchinh ;

/* 9. Viết một query để hiển thị những nhân viên mà tham gia ít nhất vào một dự án.*/
SELECT * FROM luongDA WHERE MaDA!='';

/* 10. Viết một query hiển thị phòng ban có số lượng nhân viên nhiều nhất.*/
SELECT MAX(MaPB) as NVMAX FROM phongban;

/* 11. Tính tổng số lượng của các nhân viên trong phòng Hành chính.*/
SELECT COUNT(*) AS N' Tổng số nhân viên hành chính' FROM nhanvienhanhchinh ;

/* 12. Hiển thị tống lương của các nhân viên có số CMND tận cùng bằng 9*/

SELECT right(SoCMND, 1), SoCMND
FROM nhanvien
WHERE right(SoCMND, 1) = '9'

SELECT * FROM nhanvien nv, luongDA lgda
WHERE RIGHT(nv.SoCMND, 1) = '9'  and nv.MaNV = lgda.MaNV

/* 13. Tìm nhân viên có số lương cao nhất.*/
SELECT MAX(SoTien) as GTLonNhat FROM luongDA;

/* 14. Tìm nhân viên ở phòng Hành chính có giới tính bằng ‘F’ và có mức lương > 1200000*/
SELECT * FROM luongnhanvienhanhchinh
WHERE (GioiTinh='F') AND (SoTien >1200000);

/* 15. Tổng lương trên từng phòng*/
SELECT pb.MaPB, pb.TenPB, summoney FROM phongban pb,(
SELECT MaPB, SUM(SoTien) AS summoney FROM nhanvien AS nv, luongDA AS luong WHERE nv.MaNV = luong.MaNV 
GROUP BY MaPB ) result WHERE pb.MaPB = result.MaPB;

/* 16. Liệt kê dự án có ít nhất hai người tham gia*/
SELECT MaDA FROM luongDA
 GROUP By MaDA
 Having COUNT(MaNV) >= 2;

SELECT * FROM MaDA;

/* 17. Liệt kê thông tin chi tiết của nhân viên có tên bắt đầu bằng ký tự ‘N’*/

SELECT right(MaNV, 1), MaNV
FROM nhanvien
WHERE right(MaNV, 1)='N';

/* 18. Hiển thị thông tin chi tiết của nhân viên được nhận tiền dự án trong năm 2013*/
SELECT * FROM luongDA WHERE NgayNhan= '2013-12-11';

/* 19. Hiển thị thông tin chi tiết của nhân viên không tham gia bất cứ dự án nào*/
SELECT * FROM luongDA WHERE MaDA='';

/* 20. Xoá dự án có mã dự án là da01*/
DELETE FROM luongDA WHERE MaDA='da01';

INSERT luongDA (MaDA ,MaNV,NgayNhan,SoTien)      
values ('da01','1',21-11-2016,9000000000);

/* 21. Xoá đi từ bảng LuongDA những nhân viên có mức lương 2000000*/
DELETE FROM luongDA WHERE SoTien='2000000';

/* 22. Cập nhật lại lương cho những người tham gia dự án da02 thêm 10% lương cũ  
lương cũ của dự án là 900000000 10% của lương cũ là 90000000 vậy lương mới cập nhập là 990000000*/

UPDATE luongDA
SET SoTien = '900000000'
WHERE MaDA = 'da02';
SELECT * FROM luongDA;

/* 23. Xoá các bản ghi tương ứng từ bảng NhanVien đối với những nhân viên không có mã nhân viên tồn tại trong bảng LuongDA.*/

delete from nhanvien where MaNV not in (select MaNV from luongDA );

/* 24. Viết một truy vấn đặt lại ngày vào làm của tất cả các nhân viên thuộc phòng hành chính là ngày 12/02/1999 */
UPDATE nhanvienhanhchinh
SET NgayVaoLam = 12/02/1999;
select * from nhanvienhanhchinh;