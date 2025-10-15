class Nave{
	var property velocidad = 0 
	const property velocidadMaxima = 300000 

	method propulsar(){
		velocidad = velocidad+20000.min(velocidadMaxima)
	}

	method prepararParaViajar(){
		velocidad = velocidad+15000.min(velocidadMaxima)
	}
}

class NaveDeCarga inherits Nave {

	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	method liberarCarga(){
		carga = 0
	}

	method recibirAmenaza() {
		self.liberarCarga()
	}

}

class NaveDePasajeros inherits Nave{
	var property alarma = false
	const tripulacionDeABordo = 4
	const cantidadDePasajeros = 0

	method cantTripulantesTotal() = cantidadDePasajeros + tripulacionDeABordo

	method velocidadMaximaLegal() = velocidadMaxima / self.cantTripulantesTotal() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	method recibirAmenaza() {
		alarma = true
	}

}

class NaveDeCombate inherits Nave{
	var property modo = reposo
	const property mensajesEmitidos = []

	method armasDesplegadas() = modo.armasDesplegadas()
	
	method cambiarModo() = modo.opuesto()

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = modo.invisibilidad(self)

	method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}

	override method prepararParaViajar(){
		super()
		modo.prepararParaViajar(self)
	}

}

class NaveDeCargaRadioactiva inherits NaveDeCarga{
	var property selladoAlVacio = false

	override method recibirAmenaza(){
		selladoAlVacio = true
		velocidad = 0
	}

	override method prepararParaViajar(){
		super()
		selladoAlVacio = true
	}
}


object reposo {

	var armasDesplegadas = false

	method opuesto() = ataque

	method invisibilidad(nave) = nave.velocidad() > 10000

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}

	method prepararParaViajar(nave){
		nave.emitirMensaje("Saliendo en misión")
		nave.cambiarModo()
	}

}

object ataque {
	var armasDesplegadas = true

	method opuesto() = reposo

	method invisibilidad() = not armasDesplegadas

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
		armasDesplegadas = true
	}

	method prepararParaViajar(nave){
		nave.emitirMensaje("Volviendo a la base")
	}

}
