import 'package:flutter/material.dart';

final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    /// Add all fields
    id, nombrepartida, nombrep1, nombrep2, ganador, punto, estado
  ];

  static final String id = '_id';
  static final String nombrepartida = 'nombrepartida';
  static final String nombrep1 = 'nombrep1';
  static final String nombrep2 = 'nombrep2';
  static final String ganador = 'ganador';
  static final String punto = 'punto';
  static final String estado = 'estado';
}

class Note {
  final int? id;
  final String nombrepartida;
  final String nombrep1;
  final String nombrep2;
  final String ganador;
  final int punto;
  final String estado;

  const Note({
    this.id,
    required this.nombrepartida,
    required this.nombrep1,
    required this.nombrep2,
    required this.ganador,
    required this.punto,
    required this.estado,
  });

  Note copy({
    int? id,
    String? nombrepartida,
    String? nombrep1,
    String? nombrep2,
    String? ganador,
    int? punto,
    String? estado,
  }) =>
      Note(
          id: id ?? this.id,
          nombrepartida: nombrepartida ?? this.nombrepartida,
          nombrep1: nombrep1 ?? this.nombrep1,
          nombrep2: nombrep2 ?? this.nombrep2,
          ganador: ganador ?? this.ganador,
          punto: punto ?? this.punto,
          estado: estado ?? this.estado);

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        nombrepartida: json[NoteFields.nombrepartida] as String,
        nombrep1: json[NoteFields.nombrep1] as String,
        nombrep2: json[NoteFields.nombrep2] as String,
        ganador: json[NoteFields.ganador] as String,
        punto: json[NoteFields.punto] as int,
        estado: json[NoteFields.estado] as String,
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.nombrepartida: nombrepartida,
        NoteFields.nombrep1: nombrep1,
        NoteFields.nombrep1: nombrep1,
        NoteFields.ganador: ganador,
        NoteFields.punto: punto,
        NoteFields.estado: estado,
      };
}
