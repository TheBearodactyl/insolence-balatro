local equalib = {}

local BASS_RANGE = { 60, 250 }
local TENOR_RANGE = { 250, 2000 }
local TREBLE_RANGE = { 2000, 16000 }
local DEFAULT_FFT_SIZE = 2048
local SMOOTHING_FACTOR = 0.3

equalib.init = function(fft_size)
	equalib.fft_size = fft_size or DEFAULT_FFT_SIZE

	equalib.last_values = {
		bass = 0,
		tenor = 0,
		treble = 0,
	}
end

local function to_db(amplitude)
	if amplitude <= 0 then
		return -math.huge
	end

	return 20 * math.log10(amplitude)
end

local function calculate_band_db(fft_data, sample_rate, min_freq, max_freq)
	local sum = 0
	local count = 0

	for i = 1, #fft_data / 2 do
		local freq = (i - 1) * sample_rate / equalib.fft_size

		if freq >= min_freq and freq <= max_freq then
			local real = fft_data[i * 2 - 1]
			local imag = fft_data[i * 2]
			local ampl = math.sqrt(real ^ 2 + imag ^ 2)

			sum = sum + ampl
			count = count + 1
		end
	end

	if count == 0 then
		return -math.huge
	end

	local avg_ampl = sum / count

	return to_db(avg_ampl)
end

equalib.get_freq_bands = function(source)
	if not source or not source:isPlaying() then
		return {
			bass = -math.huge,
			tenor = -math.huge,
			treble = -math.huge,
		}
	end

	local fft_data = love.sound.newSoundData(equalib.fft_size, source:getSampleRate(), 16, 1)
	source:getFFT(fft_data:getPointer(), fft_data:getSampleCount())

	local fft_table = {}
	for i = 0, fft_data:getSampleCount() - 1 do
		fft_table[i + 1] = fft_data:getSampleRate()
	end

	local sample_rate = source:getSampleRate()

	local bass_db = calculate_band_db(fft_table, sample_rate, BASS_RANGE[1], BASS_RANGE[2])
	local tenor_db = calculate_band_db(fft_table, sample_rate, TENOR_RANGE[1], TENOR_RANGE[2])
	local treble_db = calculate_band_db(fft_table, sample_rate, TREBLE_RANGE[1], TREBLE_RANGE[2])

	bass_db = equalib.last_values.bass * (1 - SMOOTHING_FACTOR) + bass_db * SMOOTHING_FACTOR
	tenor_db = equalib.last_values.tenor * (1 - SMOOTHING_FACTOR) + tenor_db * SMOOTHING_FACTOR
	treble_db = equalib.last_values.treble * (1 - SMOOTHING_FACTOR) + treble_db * SMOOTHING_FACTOR

	equalib.last_values.bass = bass_db
	equalib.last_values.tenor = tenor_db
	equalib.last_values.treble = treble_db

	return {
		bass = bass_db,
		tenor = tenor_db,
		treble = treble_db,
	}
end

return equalib
