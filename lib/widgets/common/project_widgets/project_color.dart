import 'package:flutter/material.dart';
import '../../../features/projects/domain/entities/project_entity.dart';

/// [Project.color] is a plain ARGB int (kept Flutter-free so the entity can
/// be reused outside Flutter). This gives presentation code a [Color] to
/// paint with without every call site re-wrapping it by hand.
extension ProjectColorX on Project {
  Color get uiColor => Color(color);
}
