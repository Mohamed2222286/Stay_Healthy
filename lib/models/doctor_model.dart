class Doctor {
  final String? id;
  final String? name;
  final String? specialty;
  final Map<String, dynamic> workingHours;
  final String? description;
  final String? profileImage;
  final String? address;
  final bool? isFavorite;

  Doctor({
    this.id,
    this.name,
    this.specialty,
    required this.workingHours,
    this.description,
    this.profileImage,
    this.address,
    this.isFavorite,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      specialty: json['specialty']?.toString(),
      workingHours: Map<String, String>.from(json['working_hours'] ?? {}),
      description: json['description']?.toString(),
      profileImage: json['profile_image']?.toString(),
      address: json['address']?.toString(),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'working_hours': workingHours,
      'description': description,
      'profile_image': profileImage,
      'address': address,
      'isFavorite': isFavorite,
    };
  }

  Doctor copyWith({
    String? id,
    String? name,
    String? specialty,
    Map<String, dynamic>? workingHours,
    String? description,
    String? profileImage,
    String? address,
    bool? isFavorite,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      workingHours: workingHours ?? this.workingHours,
      description: description ?? this.description,
      profileImage: profileImage ?? this.profileImage,
      address: address ?? this.address,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
class WorkingHours {
  final String start;
  final String end;

  WorkingHours({required this.start, required this.end});

  factory WorkingHours.fromJson(Map<String, dynamic> json) {
    return WorkingHours(
      start: json['start'],
      end: json['end'],
    );
  }
}

class ApiResponse {
  final Map<String, dynamic> categories;

  ApiResponse({required this.categories});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      categories: json['categories'] as Map<String, dynamic>? ?? {},
    );
  }
}

class Category {
  final List<Doctor> data;
  final int total;

  Category({required this.data, required this.total});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      data: (json['data'] as List)
          .map((doctor) => Doctor.fromJson(doctor))
          .toList(),
      total: json['total'],
    );
  }
}