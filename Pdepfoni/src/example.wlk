const hoy = new Date() 

class Linea{
	
	const property numeroTelefono
	var packs = []
	const property consumos = []
	var tipoDeLinea = black
	var deuda = 0
	
	method agregarPack(pack) = packs.add(pack)
	
	method agregarConsumo(consumo) = consumos.add(consumo)	

	method promedioCostoEntre(fecha1,fecha2) = self.consumosEntreFechas(fecha1,fecha2).map({consumo => consumo.consto()}).sum() / self.consumosEntreFechas(fecha1,fecha2).size() // packs.size()
	
	method consumosEntreFechas(fecha1,fecha2) = consumos.filter({consumo => consumo.fecha().between(fecha1,fecha2)})
	
	method costoUltimoMes() = self.consumosEntreFechas(hoy.minusDays(30),hoy).map({consumo => consumo.costo()}).sum()
	
	
	method puedeRealizarConsumo(consumo) = packs.any({pack => pack.puedeSatisfacer(consumo)})
	
	method realizarConsumo(consumo) {
		if(self.puedeRealizarConsumo(consumo)){
		consumos.add(consumo)
		packs.filter({pack => pack.puedeSatisfacer(consumo)}).last().aplicarConsumo(consumo)
		}
		else {tipoDeLinea.beneficio(self,consumo)}
	}
	
	method limpiarPacks(){ packs = packs.filter({pack =>!pack.acabado()}) }
	
	method agregarDeuda(cantidad) { deuda = deuda + cantidad}
	
	method cambiarTipoDeLinea(nuevoTipo) {tipoDeLinea = nuevoTipo}
	
}


object black{
	method beneficio(linea, consumo) {
		linea.agregarConsumo(consumo)
		linea.agregarDeuda(consumo.costo())
	}
}

object platinum{
	method beneficio(linea, consumo) {linea.agregarConsumo(consumo)}
}

object comun{
	method beneficio(linea, consumo) { linea.error("No se puede realizar este consumo") }
}

class Consumo{
	const property fecha = hoy
	const property cantidadConsumidaMB = 0
	const property cantidadConsumidaSegundos = 0
	method costo()
}

class ConsumoInternet inherits Consumo{
	const precioPorMB = 0.1

	
	override method costo() = cantidadConsumidaMB * precioPorMB
}

class ConsumoLlamadas inherits Consumo{
	const precioPorSegundosAdicionales = 0.05
	const precioFijo = 1
	
	override method costo() = 0.max(cantidadConsumidaSegundos - 30) * precioPorSegundosAdicionales + precioFijo
}


class Pack {
	
	const property vigencia
	
	method puedeSatisfacer(consumo) = self.vigente()
	method aplicarConsumo(consumo)
	method vigente() = self.vigencia() > hoy
	method acabado()
}

class PackCredito inherits Pack{
	var property credito
	
	override method puedeSatisfacer(consumo) = consumo.costo() <= credito and super(consumo)
	
	override method aplicarConsumo(consumo){credito -= consumo.costo()	}
	
	override method acabado() = credito == 0 and self.vigente()
}

class PackMBLibres inherits Pack{
	var property cantidadMB
	
	override method puedeSatisfacer(consumo) = cantidadMB >= consumo.cantidadConsumidaMB() and consumo.cantidadConsumidaSegundos() == 0 and super(consumo)
	
	override method aplicarConsumo(consumo){ cantidadMB -= consumo.cantidadConsumidaMB() } 
	
	override method acabado() = cantidadMB == 0 and self.vigente()
}

class MBLibrePlusPlus inherits PackMBLibres{

	override method puedeSatisfacer(consumo) = super(consumo) or consumo.cantidadConsumidaMB() <= 0.1
	
	override method aplicarConsumo(consumo) {
		if(self.cantidadMB() > 0){
			super(consumo)
		}
	}
	
	override method acabado() = self.vigente()	
}


class PackLlamadasGratis inherits Pack{
	override method puedeSatisfacer(consumo) = consumo.cantidadConsumidaMB() == 0 and super(consumo)

	override method aplicarConsumo(consumo){} //no hace nada
	
	override method acabado() = self.vigente() 
}

class PackInternetIlimitadoFindes inherits Pack{
	override method puedeSatisfacer(consumo) = consumo.cantidadConsumidaSegundos() == 0 and super(consumo) and self.esFinDeSemana(consumo.fecha())

	method esFinDeSemana(fecha) = fecha.dayOfWeek() == saturday or fecha.dayOfWeek() == sunday
	
	override method aplicarConsumo(consumo){} //no hace nada
	
	override method acabado() = self.vigente()
}

