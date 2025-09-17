--CLASES DE EMPLEADOS 

class Empleado {
	var nombre
	var direccion
	var estadoCivil
	var fechaNacimiento 
	var sueldoBasico

	method sueldoBruto() {
		// Método abstracto
		throw new Exception("Método sueldoBruto debe ser implementado por la subclase")
	}

	method retenciones() {
		// Método abstracto
		throw new Exception("Método retenciones debe ser implementado por la subclase")
	}

	method sueldoNeto() {
		return this.sueldoBruto() - this.retenciones()
	}

	method edad() {
		//  año actual es 2025 para el ejemplo
		return 2025 - this.fechaNacimiento
	}

	method tieneConyuge() {
		return this.estadoCivil == "Casado" || this.estadoCivil == "Casada"
	}
}

class EmpleadoPermanente inherits Empleado {
	var cantidadHijos
	var antiguedad

	override method sueldoBruto() {
		return this.sueldoBasico +
			   (150 * this.cantidadHijos) +
			   (this.tieneConyuge() ? 100 : 0) +
			   (50 * this.antiguedad)
	}

	override method retenciones() {
		var sueldo = this.sueldoBruto()
		return (0.10 * sueldo) + (20 * this.cantidadHijos) + (0.15 * sueldo)
	}
}

class EmpleadoTemporario inherits Empleado {
	var fechaFin // No se usa en los cálculos, pero se mantiene como atributo
	var cantidadHorasExtras

	override method sueldoBruto() {
		return this.sueldoBasico + (40 * this.cantidadHorasExtras)
	}

	override method retenciones() {
		var sueldo = this.sueldoBruto()
		return (0.10 * sueldo) +
			   (this.edad() > 50 ? 25 : 0) +
			   (0.10 * sueldo) +
			   (5 * this.cantidadHorasExtras)
	}
}

// CLASE RECIBO DE HABERES 

class ReciboDeHaberes {
	var nombreEmpleado
	var direccion
	var fechaEmision
	var sueldoBruto
	var sueldoNeto
	var conceptos = new Set() 

	constructor(empleado, fechaEmision) {
		this.nombreEmpleado = empleado.nombre
		this.direccion = empleado.direccion
		this.fechaEmision = fechaEmision
		this.sueldoBruto = empleado.sueldoBruto()
		this.sueldoNeto = empleado.sueldoNeto()

		
		this.conceptos.add("Sueldo Básico: $" + empleado.sueldoBasico)
		this.conceptos.add("Retenciones Totales: $" + empleado.retenciones())
	}
}

//  CLASE EMPRESA 

class Empresa {
	var nombre
	var cuit
	var empleados = new List()

	method agregarEmpleado(unEmpleado) {
		this.empleados.add(unEmpleado)
	}

	method totalSueldosNetos() {
		return this.empleados.map({ emp => emp.sueldoNeto() }).sum()
	}

	method totalSueldosBrutos() {
		return this.empleados.map({ emp => emp.sueldoBruto() }).sum()
	}

	method totalRetenciones() {
		return this.empleados.map({ emp => emp.retenciones() }).sum()
	}

	method liquidarSueldos() {
		var recibos = new List()
		this.empleados.forEach({ emp =>
			var recibo = new ReciboDeHaberes(empleado = emp, fechaEmision = "01/06/2024")
			recibos.add(recibo)
		})
		return recibos
	}
}

//2
class EmpleadoContratado inherits Empleado {
	var numeroContrato
	var medioDePago 

	override method sueldoBruto() {
		return this.sueldoBasico
	}

	override method retenciones() {
		return 50 
	}
}

// no es necesario modificar empresa gracias al polimorfismo y herencia