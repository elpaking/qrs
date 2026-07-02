# N5 ID — Documento de Inicio del MVP

**Versión:** 1.0  
**Fecha:** 2 de julio de 2026  
**Proyecto:** N5 ID  
**Primera línea comercial:** N5 PET  
**Arquitectura elegida:** BanaHosting + PHP + MySQL + panel privado por token  
**Dominio público:** `q.norte5.com`  
**Landing comercial:** `pet.norte5.com`

---

## 1. Decisión técnica

Para el MVP de N5 ID se utilizará la infraestructura que N5 ya tiene contratada en BanaHosting.

La plataforma se construirá con:

- PHP para la lógica del sistema.
- MySQL o MariaDB para la base de datos.
- HTML, CSS y JavaScript para los perfiles y paneles.
- Almacenamiento de fotografías en el mismo servidor.
- Enlaces privados con token para que cada cliente edite su perfil.
- Google Sheets únicamente como herramienta auxiliar de importación, exportación y respaldo operativo.

### No se utilizará inicialmente

- Supabase.
- WooCommerce.
- WordPress como base del sistema.
- Apps Script como base de datos.
- Un archivo HTML diferente por cada perfil.
- Cuentas con contraseña para cada cliente.
- Aplicación móvil.

La prioridad es validar el producto y comenzar a vender sin crear una plataforma sobredimensionada.

---

## 2. Objetivo del MVP

El MVP debe permitir que N5 pueda:

1. Crear un perfil desde un panel administrativo.
2. Asignar un código QR único.
3. Publicar automáticamente el perfil en una URL corta.
4. Entregar al cliente un enlace privado para editar.
5. Permitir que el cliente cambie información y fotografía.
6. Activar el modo perdido.
7. Desactivar o bloquear un perfil.
8. Mantener la misma URL pública durante toda la vida de la placa.
9. Exportar los datos para respaldos o futuras migraciones.

Ejemplo de perfil público:

```text
https://q.norte5.com/T8M2QR
```

Ejemplo de panel privado:

```text
https://q.norte5.com/editar/T8M2QR/8f3c7e2a...
```

El token privado nunca aparecerá en el código QR.

---

## 3. Separación de dominios

### `pet.norte5.com`

Será la plataforma comercial de N5 PET.

Funciones:

- Landing page.
- Explicación del producto.
- Configurador visual de la placa.
- Captación de pedidos.
- Contacto por WhatsApp.
- En el futuro: tienda y pagos.

### `q.norte5.com`

Será la plataforma tecnológica de N5 ID.

Funciones:

- Perfil público.
- Panel privado de edición.
- Panel administrativo de N5.
- Base de datos.
- Fotografías.
- Registro de escaneos.
- Plantillas PET, Biker, Bag y futuros tipos de ID.

---

## 4. Arquitectura general

```text
CLIENTE
   |
   | Escanea QR
   v
q.norte5.com/T8M2QR
   |
   v
PHP consulta MySQL
   |
   v
Carga perfil + datos PET + fotografía
   |
   v
Muestra perfil público
```

Edición:

```text
Cliente recibe enlace privado
   |
   v
q.norte5.com/editar/T8M2QR/{token}
   |
   v
PHP valida token
   |
   v
Cliente modifica datos
   |
   v
PHP valida y guarda en MySQL
   |
   v
Perfil público actualizado
```

Administración:

```text
N5 entra a /admin
   |
   v
Crea perfil
   |
   v
Genera código QR
   |
   v
Genera token privado
   |
   v
Publica perfil
```

---

## 5. Principio de diseño multproducto

N5 ID será una sola plataforma para diferentes productos:

- N5 PET.
- N5 Biker.
- N5 Bag.
- N5 Luggage.
- N5 Runner.
- N5 Kids.
- N5 Bike.
- N5 Moto.
- Otros identificadores futuros.

No se creará una base distinta para cada línea.

La plataforma tendrá:

### Núcleo universal

- Usuarios o propietarios.
- Perfiles.
- Códigos QR.
- Accesos.
- Tokens.
- Pedidos.
- Escaneos.
- Productos.
- Tipos de ID.

### Módulos especializados

- Datos de mascota.
- Datos de emergencia.
- Datos de objeto.
- Datos de vehículo.

Ejemplos:

```text
N5 PET     -> datos_pet
N5 Biker   -> datos_emergencia
N5 Runner  -> datos_emergencia
N5 Bag     -> datos_objeto
N5 Luggage -> datos_objeto
N5 Bike    -> datos_vehiculo
N5 Moto    -> datos_vehiculo
```

---

## 6. Estructura inicial de base de datos

Los nombres finales podrán llevar un prefijo como `n5_`.

### 6.1 `n5_profiles`

Contiene la información general de cualquier perfil.

Campos principales:

```text
id
public_code
type_id
public_name
public_title
public_message
photo_path
primary_phone
secondary_phone
whatsapp_phone
city
lost_mode
reward_text
status
created_at
updated_at
```

Estados sugeridos:

```text
draft
active
inactive
blocked
archived
```

### 6.2 `n5_tags`

Representa cada placa, pulsera, llavero o identificador físico.

```text
id
public_code
profile_id
product_id
serial_number
environment
status
created_at
activated_at
```

Un perfil podrá tener uno o varios tags en el futuro.

### 6.3 `n5_pet_data`

Datos específicos de mascotas.

```text
id
profile_id
species
breed
sex
age_text
color
size
sterilized
medical_conditions
allergies
medications
veterinarian_name
veterinarian_phone
special_instructions
```

### 6.4 `n5_emergency_data`

Datos para Biker, Runner, Kids o Senior.

```text
id
profile_id
blood_type
allergies
medical_conditions
medications
emergency_contact_name
emergency_contact_phone
emergency_contact_relationship
insurance_provider
policy_number
emergency_instructions
```

### 6.5 `n5_object_data`

Datos para mochila, maleta, herramientas u objetos.

```text
id
profile_id
category
brand
model
color
serial_number
description
return_instructions
reward_text
```

### 6.6 `n5_vehicle_data`

Datos para bicicleta, motocicleta u otros vehículos.

```text
id
profile_id
vehicle_type
brand
model
color
serial_number
identification_number
description
owner_notes
```

### 6.7 `n5_edit_tokens`

Permite la edición sin cuenta ni contraseña.

```text
id
profile_id
token_hash
status
expires_at
last_used_at
created_at
revoked_at
```

Reglas:

- El token debe ser largo y aleatorio.
- En la base se guarda el hash, no el token original.
- Debe poder revocarse.
- Debe poder regenerarse.
- El token no debe aparecer en el perfil público.

### 6.8 `n5_scan_events`

Registra escaneos básicos.

```text
id
tag_id
profile_id
scanned_at
ip_hash
user_agent
referrer
country_code
event_type
```

Eventos posibles:

```text
profile_view
whatsapp_click
phone_click
map_click
```

Para el MVP no se necesitan estadísticas avanzadas.

### 6.9 `n5_products`

Catálogo físico.

```text
id
sku
name
type_id
material
shape
color
status
created_at
```

### 6.10 `n5_types`

Define las líneas de N5 ID.

```text
id
slug
name
data_module
public_template
status
```

Ejemplos:

```text
pet       | N5 PET     | pet       | pet
biker     | N5 Biker   | emergency | biker
bag       | N5 Bag     | object    | bag
bike      | N5 Bike    | vehicle   | bike
```

---

## 7. Rutas del sistema

### Perfil público

```text
GET /{public_code}
```

Ejemplo:

```text
GET /T8M2QR
```

### Panel privado

```text
GET /editar/{public_code}/{token}
```

### Guardar cambios

```text
POST /api/profile/update
```

### Subir fotografía

```text
POST /api/profile/upload-image
```

### Activar modo perdido

```text
POST /api/profile/lost-mode
```

### Registrar eventos

```text
POST /api/events/track
```

### Panel administrativo

```text
GET /admin
```

### Crear perfil

```text
POST /admin/profile/create
```

### Regenerar enlace privado

```text
POST /admin/profile/regenerate-token
```

---

## 8. Estructura de carpetas sugerida

```text
q.norte5.com/
├── public/
│   ├── index.php
│   ├── .htaccess
│   ├── assets/
│   │   ├── css/
│   │   ├── js/
│   │   └── images/
│   └── uploads/
│       └── profiles/
│
├── app/
│   ├── config/
│   │   ├── database.php
│   │   └── app.php
│   ├── controllers/
│   ├── models/
│   ├── services/
│   ├── security/
│   ├── validation/
│   └── views/
│       ├── public/
│       ├── editor/
│       └── admin/
│
├── api/
│   ├── profile-update.php
│   ├── upload-image.php
│   ├── lost-mode.php
│   └── track-event.php
│
├── admin/
│   ├── index.php
│   ├── create-profile.php
│   └── profiles.php
│
├── storage/
│   ├── logs/
│   ├── backups/
│   └── exports/
│
└── scripts/
    ├── backup-database.php
    └── export-csv.php
```

La ubicación exacta dependerá de cómo BanaHosting configure el document root de `q.norte5.com`.

---

## 9. Fotografías

Las fotografías se almacenarán en BanaHosting.

Ruta sugerida:

```text
/uploads/profiles/{profile_id}/{random_name}.webp
```

Ejemplo:

```text
/uploads/profiles/903/8f7c91a2.webp
```

Reglas:

- Formatos de entrada: JPG, PNG y WebP.
- Tamaño original máximo sugerido: 5 MB.
- Conversión automática a WebP.
- Dimensión máxima sugerida: 1200 × 1200 px.
- Peso final recomendado: 150 a 500 KB.
- Nombre aleatorio.
- No utilizar el nombre del cliente o de la mascota en el archivo.
- Eliminar la imagen anterior cuando sea reemplazada, salvo que se decida conservar historial.

En MySQL se guarda únicamente la ruta del archivo.

---

## 10. Panel administrativo de N5

El panel administrativo debe permitir:

- Crear un perfil.
- Seleccionar el tipo de ID.
- Capturar información.
- Generar código público.
- Asignar producto.
- Subir fotografía.
- Generar token privado.
- Copiar enlace público.
- Copiar enlace privado.
- Activar o desactivar perfil.
- Activar modo perdido.
- Regenerar token.
- Buscar por código, nombre o teléfono.
- Exportar perfiles.
- Ver fecha de última edición.
- Ver escaneos básicos.

### Campos controlados únicamente por N5

El cliente no podrá cambiar:

- Código público.
- Tipo de ID.
- Producto.
- Estado del pago.
- Estado administrativo.
- Número de serie.
- Fecha de creación.
- Propietario interno.
- Identificador de la base.
- Historial de cambios.
- Permisos.

---

## 11. Panel privado del cliente

El cliente podrá editar inicialmente:

- Nombre público.
- Fotografía.
- Teléfono principal.
- Teléfono secundario.
- WhatsApp.
- Ciudad.
- Mensaje público.
- Recompensa.
- Indicaciones.
- Datos PET.
- Modo perdido.

El cliente no necesitará crear una contraseña.

### Riesgos del enlace privado

El enlace funciona como una llave.

Por eso:

- Debe enviarse únicamente al propietario.
- Debe existir una opción para regenerarlo.
- El token anterior debe quedar revocado.
- No debe compartirse en redes.
- No debe registrarse en Google Analytics.
- No debe aparecer en URLs públicas, QR o correos reenviables sin advertencia.

---

## 12. Perfil público N5 PET

El primer perfil debe incluir:

- Logotipo N5 PET.
- Fotografía de la mascota.
- Nombre.
- Estado perdido o seguro.
- Mensaje del dueño.
- Botón de WhatsApp.
- Botón de llamada.
- Contacto alternativo.
- Ciudad.
- Datos físicos.
- Información médica importante.
- Recompensa, si aplica.
- Aviso de privacidad.
- Identidad visual adaptable a móvil.

### Requisito principal

Debe abrir correctamente en teléfonos móviles y con conexiones lentas.

El perfil público no debe depender de WordPress, WooCommerce, Supabase ni Google Sheets.

---

## 13. Generación de códigos

Formato inicial sugerido:

```text
6 caracteres alfanuméricos
```

Ejemplos:

```text
T8M2QR
K7XM4P
B8K4TR
```

Reglas:

- Utilizar mayúsculas.
- Evitar caracteres ambiguos: `0`, `O`, `I`, `1`, `L`.
- Validar que el código no exista antes de guardarlo.
- No utilizar secuencias predecibles.
- Separar códigos de prueba y producción mediante `environment`.
- El código público nunca debe reciclarse.

---

## 14. Seguridad mínima obligatoria

### Base de datos

- Consultas preparadas con PDO.
- Usuario MySQL con permisos limitados.
- Credenciales fuera del directorio público.
- No mostrar errores SQL al usuario.
- Registro interno de errores.

### Tokens

- Generación con funciones criptográficamente seguras.
- Guardar únicamente el hash.
- Comparación segura.
- Capacidad de revocación.
- Límite de intentos.

### Formularios

- Validación en servidor.
- Protección CSRF.
- Sanitización de texto.
- Límites de longitud.
- Bloqueo de HTML no permitido.
- Control de frecuencia.

### Fotografías

- Verificar MIME real.
- Reprocesar la imagen.
- Eliminar metadatos EXIF cuando sea posible.
- Bloquear archivos ejecutables.
- No confiar en la extensión.
- Limitar tamaño y resolución.

### Administración

- Usuario y contraseña fuertes.
- Sesión segura.
- Cierre de sesión.
- Protección contra fuerza bruta.
- Acceso HTTPS obligatorio.
- Posibilidad de restringir por IP en una fase posterior.

---

## 15. Respaldos

Debe existir un proceso de respaldo independiente del hosting.

### Respaldos mínimos

- Base MySQL.
- Carpeta de fotografías.
- Archivo de configuración sin credenciales públicas.
- Exportación CSV de perfiles.
- Exportación CSV de tags.
- Exportación CSV de productos.

### Frecuencia sugerida

```text
Base de datos: diaria
Fotografías: semanal
Exportación CSV: semanal
Respaldo completo: mensual
```

Se puede utilizar un Cron Job de BanaHosting para automatizar la base de datos.

---

## 16. Migración futura

La plataforma debe estar preparada para migrar a:

- Un VPS.
- Laravel.
- Otro hosting.
- PostgreSQL.
- Supabase.
- Amazon RDS.
- DigitalOcean.
- WooCommerce como capa comercial.
- Una aplicación móvil.

### Reglas para facilitar la migración

- Mantener URLs públicas permanentes.
- Usar identificadores internos.
- Separar la lógica de la presentación.
- No guardar imágenes dentro de MySQL.
- No mezclar pedidos con perfiles.
- No crear columnas diferentes por cada producto.
- Mantener módulos separados.
- Crear exportaciones CSV.
- Documentar cambios de esquema.
- Versionar el código con Git.

### URL permanente

Aunque la tecnología cambie, esta URL debe seguir funcionando:

```text
q.norte5.com/T8M2QR
```

---

## 17. Papel de Google Sheets

Google Sheets seguirá siendo útil para:

- Importar lotes de códigos.
- Revisar inventario.
- Exportar clientes.
- Reportes comerciales.
- Conciliar pedidos.
- Preparar producción.
- Respaldar datos legibles.
- Analizar ventas.

No será la base oficial de perfiles editables.

La fuente oficial será MySQL.

---

## 18. Fases de desarrollo

### Fase 0 — Preparación

- Confirmar versión de PHP.
- Confirmar MySQL o MariaDB.
- Confirmar acceso a phpMyAdmin.
- Confirmar document root de `q.norte5.com`.
- Confirmar SSL.
- Confirmar soporte GD o ImageMagick.
- Confirmar Cron Jobs.
- Crear respaldo del subdominio.

**Resultado:** infraestructura preparada.

### Fase 1 — Base técnica

- Crear repositorio Git.
- Crear estructura de carpetas.
- Configurar entorno.
- Crear conexión PDO.
- Crear tablas.
- Insertar tipos iniciales.
- Crear manejo de errores.
- Crear archivo de configuración seguro.

**Resultado:** base funcional y conectada.

### Fase 2 — Perfil público PET

- Crear ruta dinámica.
- Buscar código.
- Consultar perfil.
- Consultar datos PET.
- Mostrar fotografía.
- Crear botones de contacto.
- Adaptar diseño móvil.
- Manejar perfil inexistente.
- Manejar perfil inactivo.
- Manejar perfil bloqueado.

**Resultado:** `q.norte5.com/T8M2QR` funciona.

### Fase 3 — Panel administrativo

- Inicio de sesión N5.
- Crear perfil.
- Generar código.
- Asignar producto.
- Guardar datos.
- Subir fotografía.
- Generar enlace privado.
- Copiar enlaces.
- Buscar perfiles.
- Activar y desactivar.

**Resultado:** N5 crea perfiles sin editar archivos.

### Fase 4 — Panel privado del cliente

- Validar token.
- Mostrar formulario.
- Editar datos permitidos.
- Cambiar fotografía.
- Activar modo perdido.
- Guardar cambios.
- Revocar y regenerar token.

**Resultado:** el cliente administra su perfil.

### Fase 5 — Escaneos y respaldos

- Registrar vistas.
- Registrar clics.
- Evitar spam básico.
- Crear reportes simples.
- Crear exportaciones.
- Programar respaldos.

**Resultado:** operación controlada.

### Fase 6 — Piloto real

- Crear entre 5 y 10 perfiles de prueba.
- Escanear desde Android y iPhone.
- Probar WhatsApp y llamada.
- Probar cambio de fotografía.
- Probar token revocado.
- Probar modo perdido.
- Probar perfil inactivo.
- Probar respaldo y restauración.
- Entregar placas piloto.

**Resultado:** MVP validado antes de vender en volumen.

---

## 19. Estimación de trabajo

Estimación para el MVP con panel privado:

| Bloque | Horas aproximadas |
|---|---:|
| Preparación y base MySQL | 4–7 |
| Estructura PHP y seguridad básica | 5–8 |
| Perfil público PET | 7–11 |
| Panel administrativo | 8–12 |
| Panel privado por token | 7–11 |
| Fotografías | 4–6 |
| Escaneos básicos | 2–4 |
| Respaldos y exportaciones | 3–5 |
| Pruebas y correcciones | 5–8 |
| **Total estimado** | **45–72 horas** |

La estimación puede reducirse si el primer MVP:

- Usa una sola fotografía.
- No incluye estadísticas visuales.
- No incluye correos automáticos.
- No incluye múltiples propietarios.
- No incluye otros tipos de ID.
- No incluye integración con pedidos.

---

## 20. Criterios de aceptación

El MVP se considera listo cuando:

- N5 puede crear un perfil desde el panel.
- El sistema genera un código único.
- El perfil abre en su URL corta.
- El perfil se ve correctamente en móvil.
- WhatsApp y llamada funcionan.
- El cliente puede editar desde su enlace.
- El cliente puede cambiar la fotografía.
- El cliente puede activar modo perdido.
- Un token revocado deja de funcionar.
- N5 puede desactivar el perfil.
- Los datos se guardan en MySQL.
- Existe un respaldo restaurable.
- No se necesita editar HTML para crear otro perfil.
- El mismo sistema soporta futuros módulos.

---

## 21. Alcance que se pospone

No se desarrollará en esta primera versión:

- Registro público.
- Contraseñas de clientes.
- Recuperación de contraseña.
- Magic links.
- Un cliente con múltiples perfiles en un dashboard.
- Pagos.
- WooCommerce.
- Suscripciones.
- Aplicación móvil.
- Notificaciones push.
- Geolocalización exacta.
- Historial avanzado.
- Integración con veterinarias.
- Biker, Bag y otros diseños completos.
- Automatización de pedidos desde WhatsApp.

Estas funciones podrán agregarse después de validar las ventas.

---

## 22. Métricas para decidir la siguiente etapa

Después de lanzar se medirán:

- Perfiles creados.
- Placas vendidas.
- Escaneos por perfil.
- Clientes que editan su perfil.
- Solicitudes de soporte.
- Cambios de fotografía.
- Activaciones de modo perdido.
- Tiempo promedio para crear una placa.
- Problemas de acceso al panel.
- Costo operativo por cliente.

### Señales para evolucionar la plataforma

- Más de una persona administra el sistema.
- Los clientes requieren varias identificaciones.
- Se necesitan pagos y pedidos automáticos.
- El panel por token causa problemas.
- El volumen de escaneos crece significativamente.
- Se lanzan varias líneas comerciales.
- El hosting compartido deja de responder adecuadamente.
- Se requiere una API externa o aplicación móvil.

---

## 23. Primera lista de tareas

### Infraestructura

- [ ] Revisar PHP disponible.
- [ ] Revisar MySQL/MariaDB.
- [ ] Confirmar acceso a phpMyAdmin.
- [ ] Confirmar SSL.
- [ ] Confirmar raíz de `q.norte5.com`.
- [ ] Confirmar GD/ImageMagick.
- [ ] Confirmar Cron Jobs.
- [ ] Crear respaldo actual.

### Proyecto

- [ ] Crear repositorio.
- [ ] Crear estructura de carpetas.
- [ ] Crear archivo `.env` o configuración protegida.
- [ ] Crear conexión PDO.
- [ ] Crear esquema SQL.
- [ ] Crear usuario administrador.
- [ ] Crear datos iniciales.

### Perfil

- [ ] Crear ruta `/{codigo}`.
- [ ] Crear plantilla PET.
- [ ] Crear estado perdido.
- [ ] Crear botones de contacto.
- [ ] Crear errores 404 e inactivo.

### Administración

- [ ] Crear login N5.
- [ ] Crear formulario de perfil.
- [ ] Crear generador de códigos.
- [ ] Crear generador de tokens.
- [ ] Crear carga de fotografía.
- [ ] Crear búsqueda.

### Cliente

- [ ] Crear panel por token.
- [ ] Crear edición de datos.
- [ ] Crear cambio de fotografía.
- [ ] Crear modo perdido.
- [ ] Crear regeneración de token.

### Operación

- [ ] Crear exportación CSV.
- [ ] Crear respaldo automático.
- [ ] Crear registro de eventos.
- [ ] Probar con códigos reales.
- [ ] Documentar procedimiento de soporte.

---

## 24. Decisión final

La ruta aprobada para N5 ID es:

```text
BanaHosting
+ PHP
+ MySQL
+ imágenes locales
+ panel privado mediante token
+ administración N5
```

Google Sheets será auxiliar.

Supabase y WooCommerce quedan fuera del MVP.

El sistema se diseñará para que los códigos y URLs impresos nunca tengan que cambiar, aunque la plataforma migre en el futuro.

La primera meta no es construir el sistema definitivo.

La primera meta es:

> Crear, publicar y editar perfiles N5 PET de forma segura, rápida y repetible, sin tocar archivos HTML por cada cliente.
