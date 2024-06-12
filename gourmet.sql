CREATE DATABASE gourmet;

USE gourmet;

CREATE TABLE clientes(
    id int auto_increment primary key,
    nombre varchar(100),
    correo_electronico varchar(100),
    telefono varchar(15),
    fecha_registro date
);

CREATE TABLE menus(
    id int auto_increment primary key,
    nombre varchar(100),
    descripcion text,
    precio decimal(10,2)
);

CREATE TABLE pedidos(
    id int auto_increment primary key,
    id_cliente int,
    fecha date,
    total decimal(10,2),
    foreign key (id_cliente) references clientes(id)
);

CREATE TABLE detallespedidos(
    id_pedido int,
    id_menu int,
    cantidad int,
    precio_unitario decimal(10,2),
    foreign key (id_pedido) references pedidos(id),
    foreign key (id_menu) references menus(id)
);