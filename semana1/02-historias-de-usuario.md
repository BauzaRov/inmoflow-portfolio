# Historias de Usuario — InmoFlow
**Proyecto:** InmoFlow – Sistema de gestión de alquileres  
**Versión:** 1.0  
**Fecha:** Abril 2026  

---

## Épica 1: Búsqueda de propiedades

### HU-01 — Buscar propiedades disponibles
**Como** inquilino interesado,  
**quiero** filtrar propiedades por barrio, tipo, ambientes y precio,  
**para** encontrar opciones que se ajusten a mis necesidades sin contactar a la agencia.

**Criterios de aceptación:**
- El sistema muestra solo propiedades con estado "disponible"
- Se puede filtrar por al menos: barrio, tipo (depto/PH/casa), ambientes y precio máximo
- Cada resultado muestra dirección, precio, ambientes y superficie
- Si no hay resultados, se muestra un mensaje indicándolo

**Prioridad MoSCoW:** Must have

---

### HU-02 — Ver detalle de una propiedad
**Como** inquilino interesado,  
**quiero** ver el detalle completo de una propiedad,  
**para** evaluar si quiero agendar una visita.

**Criterios de aceptación:**
- Se muestra: dirección, barrio, tipo, ambientes, superficie, precio, descripción y agente responsable
- El botón "Agendar visita" está visible y activo
- Si la propiedad está alquilada, el botón no aparece

**Prioridad MoSCoW:** Must have

---

## Épica 2: Gestión de visitas

### HU-03 — Agendar una visita
**Como** inquilino interesado,  
**quiero** solicitar una visita a una propiedad desde el sistema,  
**para** coordinar sin llamar a la agencia.

**Criterios de aceptación:**
- El inquilino selecciona fecha y hora deseada
- El sistema valida que la propiedad esté disponible en ese horario
- Se genera una visita con estado "pendiente"
- El agente recibe notificación de la solicitud

**Prioridad MoSCoW:** Must have

---

### HU-04 — Confirmar o cancelar una visita
**Como** agente inmobiliario,  
**quiero** confirmar o cancelar visitas solicitadas,  
**para** gestionar mi agenda y evitar superposiciones.

**Criterios de aceptación:**
- El agente ve listado de visitas pendientes asignadas a él
- Puede cambiar el estado a "confirmada" o "cancelada"
- El inquilino es notificado del cambio de estado
- Una visita cancelada libera el horario

**Prioridad MoSCoW:** Must have

---

## Épica 3: Scoring de inquilinos

### HU-05 — Registrar evaluación de un inquilino
**Como** agente inmobiliario,  
**quiero** cargar el scoring de un inquilino en el sistema,  
**para** tener un criterio objetivo al seleccionar candidatos.

**Criterios de aceptación:**
- Se puede ingresar puntaje (0-100), nivel (bajo/medio/alto), si tiene garantía y si tiene recibo de sueldo
- El sistema calcula automáticamente el nivel según el puntaje: 0-40 bajo, 41-70 medio, 71-100 alto
- Se puede agregar observaciones en texto libre
- Solo un scoring por inquilino; se puede editar

**Prioridad MoSCoW:** Must have

---

### HU-06 — Consultar scoring antes de asignar contrato
**Como** agente inmobiliario,  
**quiero** ver el scoring de un inquilino al momento de formalizar un contrato,  
**para** validar que cumple con los requisitos del propietario.

**Criterios de aceptación:**
- El scoring del inquilino es visible en la pantalla de creación de contrato
- Si el nivel es "bajo", el sistema muestra una advertencia (no bloquea)
- Si el inquilino no tiene scoring, se muestra un aviso indicándolo

**Prioridad MoSCoW:** Should have

---

## Épica 4: Gestión de contratos

### HU-07 — Registrar un contrato de alquiler
**Como** agente inmobiliario,  
**quiero** cargar un contrato de alquiler en el sistema,  
**para** tener trazabilidad del vínculo entre inquilino y propiedad.

**Criterios de aceptación:**
- Se selecciona propiedad e inquilino existentes en el sistema
- Se ingresan fecha de inicio, fecha de fin y monto mensual
- Al guardar, la propiedad cambia su estado a "alquilada"
- Se generan automáticamente los registros de pago mensuales con estado "pendiente"

**Prioridad MoSCoW:** Must have

---

### HU-08 — Ver contratos activos
**Como** agente inmobiliario,  
**quiero** ver el listado de contratos activos con su información principal,  
**para** tener visibilidad del estado de la cartera de propiedades.

**Criterios de aceptación:**
- Se listan contratos con estado "activo"
- Cada fila muestra: inquilino, propiedad, fecha de inicio, fecha de fin y monto
- Se puede filtrar por agente responsable
- Se puede acceder al detalle de cada contrato

**Prioridad MoSCoW:** Must have

---

## Épica 5: Gestión de pagos

### HU-09 — Registrar un pago mensual
**Como** agente inmobiliario,  
**quiero** registrar el pago de una cuota mensual,  
**para** mantener el historial de pagos del contrato actualizado.

**Criterios de aceptación:**
- Se selecciona el pago pendiente del contrato
- Se ingresa fecha de pago y método (transferencia, efectivo, etc.)
- El estado del pago cambia a "pagado"
- Si la fecha de pago es posterior al vencimiento, el sistema lo registra como pago tardío

**Prioridad MoSCoW:** Must have

---

### HU-10 — Ver pagos vencidos
**Como** agente inmobiliario,  
**quiero** ver un listado de pagos con estado "vencido",  
**para** gestionar la cobranza de cuotas impagas.

**Criterios de aceptación:**
- Un pago pasa a estado "vencido" automáticamente si su fecha de vencimiento es anterior a hoy y no fue pagado
- El listado muestra: inquilino, propiedad, monto, días de atraso
- Se puede ordenar por días de atraso descendente
- El agente puede agregar una nota de gestión por cada pago vencido

**Prioridad MoSCoW:** Should have

---

*Documento generado como parte del portfolio de Analista de Sistemas — InmoFlow*
