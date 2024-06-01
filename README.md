# Bouncing-Ball
bouncing_ball
Viết một chương trình sử dụng MIPS để vẽ một quả bóng di chuyển trên màn hình mô phỏng 
Bitmap của Mars). Nếu đối tượng đập vào cạnh của màn hình thì sẽ di chuyển theo chiều ngược 
lại.
Yêu cầu:
- Thiết lập màn hình ở kích thước 512x512. Kích thước pixel 1x1.
- Quả bóng là một đường tròn.
Chiều di chuyển phụ thuộc vào phím người dùng bấm, gồm có (di chuyển lên (W), di chuyển 
xuống (S), Sang trái (A), Sang phải (D) trong bộ giả lập Keyboard and Display MMIO Simulator).
Vị trí bóng ban đầu ở giữa màn hình. Tốc độ bóng di chuyển là có thay đổi không đổi. Khi người 
dùng giữ một phím nào đó (W, S, A, D) thì quả bóng sẽ tăng tốc theo hướng đó với gia tốc tuỳ
chọn. 
Gợi ý: Để làm một đối tượng di chuyển thì chúng ta sẽ xóa đối tượng ở vị trí cũ và vẽ đối tượng ở
vị trí mới. Để xóa đối tượng chúng ta chỉ cần vẽ đối tượng đó với màu là màu nền
