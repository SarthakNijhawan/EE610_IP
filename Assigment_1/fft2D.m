function output = fft2D(original_img)

	double realOut[n][n];
	double imagOut[n][n];
	double amplitudeOut[n][n];

	int height = n;
	int width = n;
	int yWave;
	int xWave;
	int ySpace;
	int xSpace;
	int i, j;
	double inputData[n][n];

	for yWave = 0:height-1
		for xWave = 0:width-1

			for ySpace = 0:height-1
				for xSpace = 0:width-1

					realOut[yWave][xWave] += (inputData[ySpace][xSpace] * cos(
							2 * PI * ((1.0 * xWave * xSpace / width) + (1.0
									* yWave * ySpace / height)))) / sqrt(
							width * height);
					imagOut[yWave][xWave] -= (inputData[ySpace][xSpace] * sin(
							2 * PI * ((1.0 * xWave * xSpace / width) + (1.0
									* yWave * ySpace / height)))) / sqrt(
							width * height);

end