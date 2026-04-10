# InmoFlow — Especificación de API REST
**Versión:** 1.0  
**Base URL:** https://qyjjcplooezvxdqscgzl.supabase.co/rest/v1  
**Autenticación:** API Key en header `apikey`  
**Formato:** JSON  

---

## Propiedades

### GET /propiedad
Lista todas las propiedades.

**Query params opcionales:**
- `estado=eq.disponible` — filtrar por estado
- `barrio=eq.Saavedra` — filtrar por barrio
- `tipo=eq.departamento` — filtrar por tipo

**Respuesta exitosa (200):**
```json
[
  {
    "id_propiedad": 1,
    "direccion": "Av. Melián 2450 3°B",
    "barrio": "Saavedra",
    "tipo": "departamento",
    "ambientes": 3,
    "superficie_m2": 72.5,
    "precio_alquiler": 350000,
    "estado": "disponible",
    "id_agente": 1
  }
]
```

### POST /propiedad
Crea una nueva propiedad.

**Body:**
```json
{
  "direccion": "Av. Melián 2450 3°B",
  "barrio": "Saavedra",
  "tipo": "departamento",
  "ambientes": 3,
  "superficie_m2": 72.5,
  "precio_alquiler": 350000,
  "estado": "disponible",
  "id_agente": 1
}
```

### PATCH /propiedad?id_propiedad=eq.{id}
Actualiza el estado de una propiedad.

**Body:**
```json
{ "estado": "alquilada" }
```

---

## Inquilinos

### GET /inquilino
Lista todos los inquilinos.

**Query params opcionales:**
- `select=*,scoring_inquilino(*)` — incluye scoring en la respuesta

**Respuesta exitosa (200):**
```json
[
  {
    "id_inquilino": 1,
    "nombre": "Valentina",
    "apellido": "López",
    "dni": "38111222",
    "email": "valen@gmail.com",
    "ocupacion": "Empleada en relación de dependencia",
    "scoring_inquilino": [
      {
        "puntaje": 85,
        "nivel": "alto",
        "tiene_garantia": true,
        "tiene_recibo": true
      }
    ]
  }
]
```

### POST /inquilino
Crea un nuevo inquilino.

**Body:**
```json
{
  "nombre": "Juan",
  "apellido": "Pérez",
  "dni": "41000111",
  "email": "juan@gmail.com",
  "telefono": "1155550000",
  "ocupacion": "Empleado en relación de dependencia"
}
```

---

## Visitas

### GET /visita
Lista todas las visitas.

**Query params opcionales:**
- `estado=eq.pendiente` — filtrar por estado
- `select=*,propiedad(*),inquilino(*)` — incluye datos relacionados

### POST /visita
Agenda una nueva visita.

**Body:**
```json
{
  "id_propiedad": 1,
  "id_inquilino": 3,
  "fecha_hora": "2026-04-10T10:00:00",
  "estado": "pendiente",
  "notas": "Primera visita"
}
```

### PATCH /visita?id_visita=eq.{id}
Confirma o cancela una visita.

**Body:**
```json
{ "estado": "confirmada" }
```

---

## Contratos

### GET /contrato
Lista todos los contratos.

**Query params opcionales:**
- `estado=eq.activo` — solo contratos activos
- `select=*,propiedad(*),inquilino(*)` — incluye datos relacionados

### POST /contrato
Registra un nuevo contrato.

**Body:**
```json
{
  "id_propiedad": 1,
  "id_inquilino": 3,
  "fecha_inicio": "2026-05-01",
  "fecha_fin": "2028-05-01",
  "monto_mensual": 350000,
  "estado": "activo"
}
```

---

## Pagos

### GET /pago
Lista todos los pagos.

**Query params opcionales:**
- `fecha_pago=is.null&fecha_vencimiento=lt.2026-04-09` — pagos vencidos
- `select=*,contrato(*,propiedad(*),inquilino(*))` — incluye datos relacionados

### PATCH /pago?id_pago=eq.{id}
Registra el cobro de un pago.

**Body:**
```json
{
  "fecha_pago": "2026-04-09",
  "estado": "pagado",
  "metodo_pago": "transferencia"
}
```

---

## Scoring

### POST /scoring_inquilino
Crea la evaluación de un inquilino.

**Body:**
```json
{
  "id_inquilino": 3,
  "puntaje": 91,
  "nivel": "alto",
  "tiene_garantia": true,
  "tiene_recibo": true,
  "observaciones": "Recibo verificado.",
  "fecha_evaluacion": "2026-04-09",
  "id_agente": 1
}
```

### PATCH /scoring_inquilino?id_inquilino=eq.{id}
Actualiza el scoring de un inquilino existente.

**Body:**
```json
{
  "puntaje": 78,
  "nivel": "alto",
  "observaciones": "Actualizado tras nueva documentación."
}
```

---

## Códigos de respuesta

| Código | Significado |
|--------|-------------|
| 200 | OK — consulta exitosa |
| 201 | Created — recurso creado |
| 204 | No Content — actualización exitosa |
| 400 | Bad Request — datos inválidos |
| 401 | Unauthorized — API key inválida |
| 404 | Not Found — recurso no encontrado |
| 409 | Conflict — violación de constraint (ej. DNI duplicado) |