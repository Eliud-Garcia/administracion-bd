// contar para cada tipo de cliente cuantos clientes tiene

db.usuarios.aggregate([
    {
        $group : {
            _id : "$tipo_cli",
            cantidad_usuarios : { $sum : 1}
        }
    },
    {
        $lookup : {
            from : "tipo_cliente",
            localField : "_id",
            foreignField: "_id",
            as : "tipo"
        }
    },
    {
        $unwind: "$tipo"
    },
    {
        $project :{ // es como el select para mostrar 
            _id : 0,
            tipo_cliente : "$tipo.nombre",
            cantidad_usuarios : 1
        }
    }
])

// traer el nombre, apellido y el tipo de cliente (sin informacion adicional)

db.usuarios.aggregate([
    { //el inner join
        $lookup : {
            from : "tipo_cliente",
            localField : "tipo_cli",
            foreignField : "_id",
            as : "tipo"

        }
    },
    { //eliminar documentos sin coincidencia
        $unwind : "$tipo"
    },
    { //el select
        $project : {
            _id : 0,
            nombre : 1,
            apellido : 1,
            tipo_cliente : "$tipo.nombre"
        }
    }
])

/*
VARIOS $lookup (INNER JOIN)

se pueden seguir haciendo mas "inner join" con el 
$lookup y el $unwind

db.usuarios.aggregate([

    {
        $lookup: {
            from: "tipo_cliente",
            localField: "tipo_cli",
            foreignField: "_id",
            as: "tipo"
        }
    },

    {
        $unwind: "$tipo"
    },

    {
        $lookup: {
            from: "ciudades",
            localField: "ciudad_id",
            foreignField: "_id",
            as: "ciudad"
        }
    },

    {
        $unwind: "$ciudad"
    },
    
    {
        $project: {
            _id: 0,
            nombre: 1,
            tipo_cliente: "$tipo.nombre",
            ciudad: "$ciudad.nombre"
        }
    }
])
*/