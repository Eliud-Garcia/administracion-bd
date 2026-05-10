/* 
-actualizar los registros existentes
se puede actulizar un campo que no existe,
por ejemplo edad no lo tiene el registro pero se puede agregar
*/

/*
ANTES
{
    _id: ObjectId('6a00d6c81159c816ab9df8aa'),
    nombre: 'pepe',
    apellido: 'perez',
    tipo_cli: ObjectId('6a00d5f21159c816ab9df8a8'),
  }
*/

db.usuarios.updateOne(
  { _id: ObjectId('6a00d6c81159c816ab9df8aa') },
  { $set: { edad: 30 } }
)

/*
DESPUES
 {
    _id: ObjectId('6a00d6c81159c816ab9df8aa'),
    nombre: 'pepe',
    apellido: 'perez',
    tipo_cli: ObjectId('6a00d5f21159c816ab9df8a8'),
    edad: 30
  }

*/

/*actualizar campos de objetos anidados */

db.usuarios.updateOne(
    { _id : ObjectId('6a00d54d1159c816ab9df8a3')},
    {
        $set : 
        {
            "direccion.ciudad" : "medellin",
            "direccion.barrio" : "el poblado",
            "direccion.numero" : 123
        }
    }
)

db.usuarios.updateOne(
    {_id : ObjectId('6a00d6c81159c816ab9df8a9')},
    {
        $set :
        {direccion: { ciudad: 'medellin', barrio: 'el poblado', numero: 123 }}
    }
)

/*actualizar varios objetos que cumplen una condición */
/*todos los usuarios con ciudad "florencia" */
db.usuarios.updateMany(
  { "direccion.ciudad": "medellin" },
  {
    $set: {
      "direccion.ciudad": "MEDELLIN"
    }
  }
)
