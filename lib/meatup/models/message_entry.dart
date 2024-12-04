class MeatupMessageEntry {
  String id; // ID unik untuk pesan
  int userId; // ID pengguna yang mengirim pesan
  String userName; // Nama pengguna
  String message; // Konten pesan
  DateTime timestamp; // Waktu pesan dikirim
  bool isImportant; // Indikasi apakah pesan penting atau tidak

  MeatupMessageEntry({
    required this.id,
    required this.userId,
    required this.userName,
    required this.message,
    required this.timestamp,
    this.isImportant = false, // Default ke false jika tidak ditentukan
  });

  // Factory method untuk membuat pesan langsung
  factory MeatupMessageEntry.create({
    required String id,
    required int userId,
    required String userName,
    required String message,
    DateTime? timestamp,
    bool isImportant = false,
  }) {
    return MeatupMessageEntry(
      id: id,
      userId: userId,
      userName: userName,
      message: message,
      timestamp: timestamp ?? DateTime.now(), // Gunakan waktu saat ini jika tidak ditentukan
      isImportant: isImportant,
    );
  }

  // Metode untuk mencetak informasi pesan
  String printMessage() {
    return "[${timestamp.toIso8601String()}] $userName: $message${isImportant ? " (IMPORTANT)" : ""}";
  }
}