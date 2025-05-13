MVVM là một mô hình kiến trúc phần mềm giúp tách biệt logic nghiệp vụ, giao diện người dùng, và dữ liệu. Các thành phần chính bao gồm:

Model: Đại diện cho dữ liệu và logic nghiệp vụ. Trong trường hợp này, UserModels là Model, chứa thông tin người dùng (như tên, email, vai trò, v.v.) và cách chuyển đổi dữ liệu (ví dụ: từ Firestore sang đối tượng Dart).
View: Giao diện người dùng (UI), hiển thị dữ liệu từ ViewModel và gửi các sự kiện người dùng (như nhấn nút, nhập văn bản) đến ViewModel. Trong Flutter, View thường là các Widget.
ViewModel: Cầu nối giữa Model và View. ViewModel xử lý logic nghiệp vụ (như lấy dữ liệu từ Firestore, lọc danh sách người dùng, thêm/sửa/xóa người dùng) và cung cấp dữ liệu cho View thông qua các thuộc tính hoặc trạng thái.
Lợi ích của MVVM:

Tách biệt trách nhiệm: View chỉ hiển thị, ViewModel xử lý logic, Model quản lý dữ liệu.
Dễ bảo trì: Mã rõ ràng, dễ sửa đổi và kiểm tra.
Tái sử dụng: ViewModel có thể được sử dụng cho nhiều View khác nhau.
Kiểm tra đơn vị (Unit Testing): ViewModel không phụ thuộc vào UI, dễ viết unit test.
