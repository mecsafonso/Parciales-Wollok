object empleados{
	const property listaEmpleados = new List()
	
	method mejorEmpleadoSegun(criterio) = criterio.mejorDe(listaEmpleados)
}

object totalComisiones{
	method mejorDe(listaEmpleados) = listaEmpleados.max({empleado => empleado.totalComisiones()})
}

object cantidadOperacionesCerradas{
	method mejorDe(listaEmpleados) = listaEmpleados.max({empleado => empleado.cantidadOperacionesCerradas()})
}

object cantidadReservas{
	method mejorDe(listaEmpleados) = listaEmpleados.max({empleado => empleado.cantidadReservas()})
}



class Empleado{
	const property operacionesRealizadas = new List()
	const property operacionesReservadas = new List()
	
	method reservar(operacion) { 
		operacion.reservar()
		operacionesReservadas.add(operacion)
	}
	
	method concretar(operacion) {
		if(operacion.puedeConcretarse()){
			operacionesRealizadas.add(operacion)
		}
		else self.error("No se puede concretar la operacion")
	}
	
	method totalComisiones() = operacionesRealizadas.map({operacion => operacion.comisionEmpleado()}).sum()
	method cantidadOperacionesCerradas() = operacionesRealizadas.size()
	method cantidadReservas() = operacionesReservadas.size()
	
	// Esto se da cuando ambos han cerrado operaciones en la misma zona y alguno de lo dos concretó alguna vez una operación que había reservado el otro.
	
	method tendraProblemasCon(otroEmpleado) = self.repiteZonaCon(otroEmpleado) && self.disputoOperacionCon(otroEmpleado)
	
	method repiteZonaCon(otroEmpleado) = self.zonasDeOperaciones(otroEmpleado).any({zona => self.zonasDeOperaciones(self).contains(zona)})
	
	method disputoOperacionCon(otroEmpleado) = operacionesRealizadas.any({operacion => otroEmpleado.operacionesReservadas().contains(operacion)}) or otroEmpleado.disputoOperacionCon(self)
	
	method zonasDeOperaciones(empleado) =  empleado.operacionesRealizadas().map({operacion => operacion.zona()})
}

class Operacion{
	const property tipoInmueble
	const property tamanioInmueble
	const property cantidadAmbientes
	const property tipoDeOperacion
	const property zona
	var property reservada
	
	method comisionEmpleado()
	method reservar() {self.reservada(true)}
	method puedeConcretarse() = reservada 
}


class Alquiler inherits Operacion{
	const property cantidadMeses
	
	override method comisionEmpleado() = cantidadMeses * tipoInmueble.valorInmueble(tamanioInmueble,cantidadAmbientes,zona.plusPorZona()) / 50000

}

class Venta inherits Operacion{
	const property porcentaje
	
	override method comisionEmpleado() = tipoInmueble.valorInmueble(tamanioInmueble,cantidadAmbientes,zona.plusPorZona()) * porcentaje

	override method puedeConcretarse() = reservada and self.tipoInmueble().puedeVenderse()
}

class Casa{
	const property valorParticular = 10
	
	method puedeVenderse() = true 
	
	method valorInmueble(tamanio,cantidadAmbientes,plus) = valorParticular + plus
}

object ph{
	method puedeVenderse() = true 
	
	method valorInmueble(tamanio,cantidadAmbientes,plus) = 500000.max(14000 * tamanio) + plus
}

object departamento{
	method puedeVenderse() = true 
	
	method valorInmueble(tamanio,cantidadAmbientes,plus) = 350000 * cantidadAmbientes + plus
}

class Zona{
	const property plusPorZona = 0
}

class Local inherits Casa{
	const property tipoDeLocal
	
	override method puedeVenderse() = false 
	
	
	override method valorInmueble(tamanio,cantidadAmbientes,plus) = tipoDeLocal.precio(super(tamanio,cantidadAmbientes,plus))
}

object galpon{
	method precio(precioPropiedad) = precioPropiedad / 2
}

object aLaCalle{
	
	const property montoFijo = 0
	
	method precio(precioPropiedad) = precioPropiedad + montoFijo
}

