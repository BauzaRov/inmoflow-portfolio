-- Datos
INSERT INTO agente (nombre, apellido, email, telefono) VALUES
  ('Lucía', 'Fernández', 'lucia@inmoflow.com', '1155550001'),
  ('Marcos', 'Giménez', 'marcos@inmoflow.com', '1155550002');

INSERT INTO propiedad (direccion, barrio, tipo, ambientes, superficie_m2, precio_alquiler, estado, id_agente) VALUES
  ('Av. Melián 2450 3°B', 'Saavedra', 'departamento', 3, 72.5, 350000, 'disponible', 1),
  ('Av. Balbín 4100 PB', 'Saavedra', 'PH', 4, 95.0, 480000, 'disponible', 2),
  ('Av. Triunvirato 3200 7°A', 'Villa Urquiza', 'departamento', 2, 55.0, 270000, 'alquilada', 1);

INSERT INTO inquilino (nombre, apellido, dni, email, telefono, ocupacion) VALUES
  ('Valentina', 'López', '38111222', 'valen@gmail.com', '1144440001', 'Empleada en relación de dependencia'),
  ('Federico', 'Ramos', '35444555', 'fede.ramos@gmail.com', '1144440002', 'Monotributista');

INSERT INTO scoring_inquilino (id_inquilino, puntaje, nivel, tiene_garantia, tiene_recibo, observaciones, fecha_evaluacion, id_agente) VALUES
  (1, 85, 'alto', TRUE, TRUE, 'Recibo verificado. Garantía propietaria en CABA.', '2025-03-10', 1),
  (2, 62, 'medio', FALSE, TRUE, 'Monotributista cat. D. Sin garantía propia.', '2025-03-12', 2);

INSERT INTO visita (id_propiedad, id_inquilino, fecha_hora, estado, notas) VALUES
  (1, 1, '2025-03-15 11:00:00', 'realizada', 'Le interesó. Consulta por precio.'),
  (2, 2, '2025-03-18 16:30:00', 'realizada', 'Interesado. Confirmar garantía.');

INSERT INTO contrato (id_propiedad, id_inquilino, fecha_inicio, fecha_fin, monto_mensual, estado) VALUES
  (3, 1, '2025-01-01', '2027-01-01', 270000, 'activo');

INSERT INTO pago (id_contrato, fecha_vencimiento, fecha_pago, monto, estado, metodo_pago) VALUES
  (1, '2025-01-10', '2025-01-08', 270000, 'pagado', 'transferencia'),
  (1, '2025-02-10', '2025-02-11', 270000, 'pagado', 'transferencia'),
  (1, '2025-03-10', NULL, 270000, 'pendiente', NULL);

-- Query 1: Propiedades disponibles con su agente
SELECT p.direccion, p.barrio, p.tipo, p.ambientes, p.precio_alquiler,
    a.nombre || ' ' || a.apellido AS agente
FROM propiedad p
JOIN agente a ON p.id_agente = a.id_agente
WHERE p.estado = 'disponible';

-- Query 2: Inquilinos con su scoring
SELECT i.nombre || ' ' || i.apellido AS inquilino, i.ocupacion,
    s.puntaje, s.nivel, s.tiene_garantia, s.tiene_recibo
FROM inquilino i
JOIN scoring_inquilino s ON i.id_inquilino = s.id_inquilino
ORDER BY s.puntaje DESC;

-- Query 3: Visitas con propiedad e inquilino
SELECT v.fecha_hora, p.direccion,
    i.nombre || ' ' || i.apellido AS inquilino, v.estado, v.notas
FROM visita v
JOIN propiedad p ON v.id_propiedad = p.id_propiedad
JOIN inquilino i ON v.id_inquilino = i.id_inquilino;

-- Query 4: Pagos del contrato activo
SELECT i.nombre || ' ' || i.apellido AS inquilino, p.direccion,
    pg.fecha_vencimiento, pg.fecha_pago, pg.monto, pg.estado
FROM pago pg
JOIN contrato c ON pg.id_contrato = c.id_contrato
JOIN propiedad p ON c.id_propiedad = p.id_propiedad
JOIN inquilino i ON c.id_inquilino = i.id_inquilino
ORDER BY pg.fecha_vencimiento;