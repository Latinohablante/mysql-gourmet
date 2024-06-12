# Responsable: Elkin Gabirel Niño sánchez
# Base de datos asignada: Gourmet Delight

## Consultas

### 1. Obtener la lista de todos los menús con sus precios

```sql
SELECT nombre, precio
from menus;
```

### 2. Encontrar todos los pedidos realizados por el cliente 'Juan Perez'

```sql
SELECT p.id as id, p.fecha as fecha, p.total as total
from pedidos p
join clientes cl on p.id_cliente = cl.id
where cl.nombre = "Juan Perez";
```

### 3. Listar los detalles de todos los pedidos, incluyendo el nombre del menú, cantidad y precio unitario

```sql
SELECT p.id as PedidoID, m.nombre as Menu, dp.cantidad as cantidad, dp.precio_unitario as precio_unitario
from pedidos p
join detallespedidos dp on p.id = dp.id_pedido
join menus m on dp.id_menu = m.id;
```

### 4. Calcular el total gastado por cada cliente en todos sus pedidos

```sql
SELECT cl.nombre as nombre, SUM(p.total) as TotalGastado
FROM pedidos p
JOIN clientes cl ON p.id_cliente = cl.id
group by cl.nombre;
```

### 5. Encontrar los menús con un precio mayor a $10

```sql
SELECT nombre, precio
FROM menus
WHERE precio > 10;
```

### 6. Obtener el menú más caro pedido al menos una vez

```sql
SELECT nombre, precio
FROM menus
WHERE precio = (SELECT MAX(precio_unitario) FROM detallespedidos);
```

### 7. Listar los clientes que han realizado más de un pedido

```sql
SELECT cl.nombre, cl.correo_electronico, COUNT(p.id_cliente)
FROM pedidos p
JOIN clientes cl ON p.id_cliente = cl.id
GROUP BY cl.nombre, cl.correo_electronico
HAVING COUNT(p.id_cliente) >= 2;
```

### 8. Obtener el cliente con el mayor gasto total

```sql
SELECT cl.nombre
from clientes cl
JOIN pedidos p on p.id_cliente = cl.id
GROUP BY cl.nombre
HAVING SUM(total)
ORDER BY SUM(total) DESC
LIMIT 1;
```

### 9. Mostrar el pedido más reciente de cada cliente

```sql
SELECT cl.nombre, MAX(p.fecha) as fecha
FROM pedidos p
JOIN clientes cl ON cl.id = p.id_cliente
GROUP BY cl.id;
```


### 10. Obtener el detalle de pedidos (menús y cantidades) para el cliente 'Juan Perez'.

```sql
SELECT dp.id_pedido, m.nombre, dp.cantidad, dp.precio_unitario
FROM detallespedidos dp
JOIN menus m ON m.id = dp.id_menu
JOIN pedidos p ON dp.id_pedido = p.id
JOIN clientes cl ON cl.id = p.id_cliente
WHERE cl.nombre = "Juan Perez";
```

## Procedimientos

### 1. Crear un procedimiento almacenado para agregar un nuevo cliente

Crea un procedimiento almacenado llamado AgregarCliente que reciba como parámetros el nombre, correo electrónico, teléfono y fecha de registro de un nuevo cliente y lo inserte en la tabla Clientes

```sql
DELIMITER //
CREATE PROCEDURE AgregarCliente(
    IN p_nombre varchar(100),
    IN p_correo_electronico varchar(100),
    IN p_telefono varchar(15),
    IN P_fecha_registro date
)
BEGIN
    INSERT INTO clientes VALUES (p_nombre, p_correo_electronico, p_telefono, p_fecha_registro);
END //
DELIMITER ;

CALL AgregarCliente();
```

### 2. Crear un procedimiento almacenado para obtener los detalles de un pedido

Crea un procedimiento almacenado llamado ObtenerDetallesPedido que reciba
como parámetro el ID del pedido y devuelva los detalles del pedido, incluyendo el nombre del menú, cantidad y precio unitario.

```sql
DELIMITER //
CREATE PROCEDURE ObtenerDetallesPedido(
    IN p_id_pedido int
)
BEGIN
    SELECT m.nombre, dp.cantidad, dp.precio_unitario
    FROM detallespedidos dp
    JOIN menus m ON m.id = dp.id_menu
    WHERE id_pedido = p_id_pedido;
END //
DELIMITER ;

CALL ObtenerDetallesPedido(1);
```


### 3. Crear un procedimiento almacenado para actualizar el precio de un menú

Crea un procedimiento almacenado llamado ActualizarPrecioMenu que reciba
como parámetros el ID del menú y el nuevo precio, y actualice el precio del menú en la tabla Menus.

```sql
DELIMITER //
CREATE PROCEDURE ActualizarPrecioMenu(
    IN p_id int,
    IN p_precio decimal(10,2)
)
BEGIN
    UPDATE menus
    SET  precio = p_precio
    WHERE id = p_id;
END //
DELIMITER ;

CALL ActualizarPrecioMenu(1, 12.49);
```


### 4. Crear un procedimiento almacenado para eliminar un cliente y sus pedidos

Crea un procedimiento almacenado llamado EliminarCliente que reciba como
parámetro el ID del cliente y elimine el cliente junto con todos sus pedidos y los detalles de los pedidos.

```sql
DELIMITER //
CREATE PROCEDURE EliminarCliente(
    IN p_id int
)
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;
    DELETE cl, p, dp
    FROM clientes as cl
    JOIN pedidos as p ON cl.id = p.id_cliente
    JOIN detallespedidos as dp ON p.id = dp.id_pedido
    WHERE cl.id = p_id;
    SET FOREIGN_KEY_CHECKS = 1;
END //
DELIMITER ;

CALL EliminarCliente(1);
```


### 5. Crear un procedimiento almacenado para obtener el total gastado por un cliente

Crea un procedimiento almacenado llamado TotalGastadoPorCliente que reciba
como parámetro el ID del cliente y devuelva el total gastado por ese cliente en todos sus pedidos.

```sql
DELIMITER //
CREATE PROCEDURE TotalGastadoPorCliente(
    IN p_id int
)
BEGIN
    SELECT SUM(total) 
    FROM pedidos 
    WHERE id_cliente = p_id;
END //
DELIMITER ;

CALL TotalGastadoPorCliente(1);
```









