
// para crear la base de datos

use nombre_db;

// crear collection

db.createCollection("tabla")


// listar collections
show collections

// para insertar 

db.tabla.insertOne({ nombre: "ejemplo", fecha: new Date() })

// para ver los registros de una coleccion

db.tabla.find()


// insertar un registro con un campo que tiene muchos valores

db.tabla.insertOne({ nombre: "ejemplo", telefonos:[{"numero": 123}, {"numero": 345}] })

// insertar un registro que tenga una direccion compuesta

db.tabla.insertOne({ nombre: "ejemplo", direccion : {ciudad : "florencia", barrio : "porvenir", numero : 12} })



// simular una relacion de muchos a muchos

db.persona.insertOne(
    {nombre: "jhonnier", apellido : "garcia",
    hobbies : [
        {nombre : "lectura", duracion : 2, estado : "inactivo"},
        {nombre : "deporte", duracion : 3, estado : "activo"},
        ]
    }
)


db.createCollection("tipo_cliente")

db.tipo_cliente.insertMany([
    {codigo: 1, nombre : "mayorista"},
    {codigo: 2, nombre : "minorista"},
    {codigo: 3, nombre : "vip"},
    {codigo: 4, nombre : "pro"}
]
)

db.createCollection("cliente")

//asociar una persona a un tipo de cliente
db.cliente.insertMany([
    {nombre : "jhonnier", apellido : "garcia", tipo_cli : ObjectId('69fcb54cabd65e29e4abc118')},
    {nombre : "pepe", apellido : "perez", tipo_cli : ObjectId('69fcb54cabd65e29e4abc11a')},
]
)

db.cliente.aggregate([
  {
    $lookup: {
      from: "tipo_cliente",        // colección foranea
      localField: "tipo_cli",      // campo en "cliente"
      foreignField: "_id",         // campo en "tipo_cliente"
      as: "info_tipo"              // nombre del resultado
    }
  }
])

db.usuarios.insertOne(
  {nombre : "Juan", apellido : "Gonzales", tipo_cli : ObjectId('69fcb54cabd65e29e4abc11a')}
)