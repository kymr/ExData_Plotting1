# Step 1. init variables
filePath <- "household_power_consumption.txt"
targetDateString <- c("1/2/2007", "2/2/2007")
targetData <- vector()


# Step 2. read file
sourceFile <- file(filePath, open = "r")
columnClasses <- c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric")
columnNames <- strsplit(readLines(filePath, n = 1), ';')[[1]]
data <- read.table(text = "", colClasses = columnClasses, col.names = columnNames)

index <- 1
while (length(input <- readLines(sourceFile, n = 1000)) > 0) {
    for (i in 1:length(input)) {
        first8Chars <- substring(input[i], 1, 8)
        
        if (first8Chars == targetDateString[1] | first8Chars == targetDateString[2]) {
            strChunkedInputLine <- strsplit(input[i], ';')[[1]]
            data[index, 1:2] <- strChunkedInputLine[1:2]
            data[index, 3:9] <- as.numeric(strChunkedInputLine[3:9])
            index <- index + 1
        }
    }
}

close(sourceFile)


# Step 3. save graphic to png
png(filename = "plot3.png", width = 480, height = 480)

d1 <- as.Date(data$Date, "%d/%m/%Y")
data$datetime <- strptime(paste(d1, data$Time), format = "%Y-%m-%d %H:%M:%S")
Sys.setlocale("LC_TIME", "C")

plot(data$datetime, data$Sub_metering_1, xlab = "", ylab = "Energy sub metering", type = "n")
points(data$datetime, data$Sub_metering_1, type = "l", col = "black")
points(data$datetime, data$Sub_metering_2, type = "l", col = "red")
points(data$datetime, data$Sub_metering_3, type = "l", col = "blue")
legend("topright", lty = 1, lwd = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2",  "Sub_metering_3"))

dev.off()
