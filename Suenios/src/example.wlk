class Persona{
	
	const property sueniosPendientes = new List()
	const property sueniosCumplidos = new List()
	
	var property felicidoneos = 0
	const property edad
	const property carrerasDeseadas = new List()
	const property carrerasFinalizadas = new List()
	const property salarioDeseado 
	const property hijos = new List() // quiza con numeros
	const property lugaresVisitados = new List()
	var property trabajo
	
	const property tipoDePersona
	
	method cumplirSuenio(suenio){
		if(suenio.puedeCumplirlo(self)){
			sueniosCumplidos.add(suenio)
			sueniosPendientes.remove(suenio)
			suenio.efectos(self)
		}
		else self.error("No se puede cumplir el sueño :( =(") 
	}
	
	method ganarFelicidonios(cantidad) {felicidoneos += cantidad}
	
	method recibirse(carrera) = carrerasFinalizadas.add(carrera)
	method nuevoHijo(hijo) = hijos.add(hijo)
	method registrarViaje(destino) = lugaresVisitados.add(destino)
	method nuevoEmpleo(empleo) {self.trabajo(empleo)}
	
	method cumplirSuienoMasPreciado(){ self.cumplirSuenio(tipoDePersona.suenioMasPreciado(self))}
	
	method esFeliz() = self.felicidoneos() > self.felicidoneosPendientes()
	
	method felicidoneosPendientes() = self.sueniosPendientes().map({suenio => suenio.felicidonios()}).sum()
	
	method esAmbiciosa() = 3 < self.sueniosAmbiciosos().size()
	
	method sueniosAmbiciosos() = (sueniosPendientes + sueniosCumplidos).filter({suenio => suenio.esAmbicioso()})
	
}

class Suenios{
	const felicidonios
	
	method esAmbicioso() = self.felicidonios() > 100
	
	method felicidonios() = felicidonios
	
	method puedeCumplirlo(persona) = true
	method efectos(persona) {persona.ganarFelicidonios(felicidonios)}
}

class RecibirseDeCarrera inherits Suenios {
	const carreraDelSuenio
	
	override method puedeCumplirlo(persona) = !self.carreraRepetida(persona) and self.carreraDeseada(persona)
	
	method carreraRepetida(persona) = persona.carrerasFinalizadas().contains(carreraDelSuenio)
	
	method carreraDeseada(persona) = persona.carrerasDeseadas().any({carrera => carrera == carreraDelSuenio}) // se puede ahcer con contains

	override method efectos(persona) { persona.recibirse(carreraDelSuenio)
		super(persona)
	} 
}

class TenerHijo inherits Suenios{
	const hijoNuevo
	
	
	
	override method efectos(persona) { persona.nuevoHijo(hijoNuevo) 
		super(persona)
	} 
}

class AdoptarHijo inherits TenerHijo{
	
	override method puedeCumplirlo(persona) = persona.hijos().isEmpty()
	
	override method efectos(persona) { persona.nuevoHijo(hijoNuevo)
		super(persona)
	} 
}

class Viajar inherits Suenios{
	const destino
	
	override method efectos(persona) { persona.registrarViaje(destino)
		super(persona)
	} 
}

class ConseguirLaburoBienPago inherits Suenios{
	const salarioEstipulado
	const laburo
	
	override method puedeCumplirlo(persona) = persona.salarioDeseado() <= salarioEstipulado
	
	override method efectos(persona){ persona.nuevoEmpleo(laburo)
		super(persona)
	}
}


// Punto 2

class SuenioMultiple inherits Suenios{
	const listaDeSuenios 
	
	override method felicidonios() = listaDeSuenios.map({suenio => suenio.felicidonios()}).sum()
	
	override method puedeCumplirlo(persona) = listaDeSuenios.all({suenio => suenio.puedeCumplirlo(persona)})
	
	override method efectos(persona){listaDeSuenios.forEach({suenio => suenio.efectos(persona)})}
	
}

// Punto 3


object realista{
	method suenioMasPreciado(persona) = persona.sueniosPendientes().max({suenios => suenios.felicidones()})
}

object alocado{
	method suenioMasPreciado(persona) = persona.sueniosPendientes().anyOne() 
	
}

object obsesivo{
	method suenioMasPreciado(persona) = persona.sueniosPendientes().first()
}











