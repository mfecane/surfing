class_name Lib

static func map(input: float, inputStart: float, inputEnd: float, outputStart: float, outputEnd: float, clamped: bool = false):
	var output = outputStart + ((outputEnd - outputStart) / (inputEnd - inputStart)) * (input - inputStart)
	if clamped and output > outputEnd: 
		return outputEnd
	if clamped and output < outputStart: 
		return outputStart
	return output
