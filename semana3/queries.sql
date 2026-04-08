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


-- Reporte 1: Resumen de cartera por estado
SELECT 
    estado,
    COUNT(*) AS cantidad,
    ROUND(AVG(precio_alquiler), 0) AS precio_promedio,
    MIN(precio_alquiler) AS precio_minimo,
    MAX(precio_alquiler) AS precio_maximo
FROM propiedad
GROUP BY estado
ORDER BY cantidad DESC;

INSERT INTO inquilino (nombre, apellido, dni, email, telefono, ocupacion) VALUES
  ('Carolina', 'Méndez', '40222333', 'caro.mendez@gmail.com', '1133330001', 'Empleada en relación de dependencia');

INSERT INTO scoring_inquilino (id_inquilino, puntaje, nivel, tiene_garantia, tiene_recibo, fecha_evaluacion, id_agente) VALUES
  (3, 91, 'alto', TRUE, TRUE, '2025-03-20', 1);
  
-- Reporte 2: Inquilinos con scoring alto sin contrato activo
SELECT 
    i.nombre || ' ' || i.apellido AS inquilino,
    i.email,
    i.telefono,
    s.puntaje,
    s.nivel,
    s.tiene_garantia
FROM inquilino i
JOIN scoring_inquilino s ON i.id_inquilino = s.id_inquilino
WHERE s.nivel = 'alto'
AND i.id_inquilino NOT IN (
    SELECT id_inquilino 
    FROM contrato 
    WHERE estado = 'activo'
);

-- Reporte 3: Pagos vencidos con días de atraso
SELECT 
    i.nombre || ' ' || i.apellido AS inquilino,
    p.direccion,
    pg.fecha_vencimiento,
    CURRENT_DATE - pg.fecha_vencimiento AS dias_de_atraso,
    pg.monto,
    CASE 
        WHEN CURRENT_DATE - pg.fecha_vencimiento > 30 THEN 'crítico'
        WHEN CURRENT_DATE - pg.fecha_vencimiento > 10 THEN 'moderado'
        ELSE 'leve'
    END AS nivel_alerta
FROM pago pg
JOIN contrato c ON pg.id_contrato = c.id_contrato
JOIN propiedad p ON c.id_propiedad = p.id_propiedad
JOIN inquilino i ON c.id_inquilino = i.id_inquilino
WHERE pg.fecha_pago IS NULL
AND pg.fecha_vencimiento < CURRENT_DATE
ORDER BY dias_de_atraso DESC;

-- Reporte 4: Ranking de agentes por propiedades gestionadas
SELECT 
    a.nombre || ' ' || a.apellido AS agente,
    COUNT(p.id_propiedad) AS total_propiedades,
    SUM(CASE WHEN p.estado = 'disponible' THEN 1 ELSE 0 END) AS disponibles,
    SUM(CASE WHEN p.estado = 'alquilada' THEN 1 ELSE 0 END) AS alquiladas,
    ROUND(AVG(p.precio_alquiler), 0) AS precio_promedio
FROM agente a
LEFT JOIN propiedad p ON a.id_agente = p.id_agente
GROUP BY a.id_agente, a.nombre, a.apellido
ORDER BY total_propiedades DESC;

-- Reporte 5: Vista de contratos activos
CREATE VIEW v_contratos_activos AS
SELECT 
    c.id_contrato,
    i.nombre || ' ' || i.apellido AS inquilino,
    i.email,
    i.telefono,
    p.direccion,
    p.barrio,
    a.nombre || ' ' || a.apellido AS agente,
    c.fecha_inicio,
    c.fecha_fin,
    c.monto_mensual,
    s.puntaje AS scoring_inquilino,
    s.nivel AS nivel_scoring
FROM contrato c
JOIN inquilino i ON c.id_inquilino = i.id_inquilino
JOIN propiedad p ON c.id_propiedad = p.id_propiedad
JOIN agente a ON p.id_agente = a.id_agente
LEFT JOIN scoring_inquilino s ON i.id_inquilino = s.id_inquilino
WHERE c.estado = 'activo';

-- Consultar la vista
SELECT * FROM v_contratos_activos;