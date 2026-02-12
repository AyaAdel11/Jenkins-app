# تغيير الصورة لصورة عامة ومستقرة ولا تتطلب تسجيل دخول خاص
FROM maven:3.9.6-eclipse-temurin-17

# Set working directory in container
WORKDIR /app

# Copy JAR file (تأكدي أن الاسم يطابق الناتج من عمل mvn package)
COPY target/*.jar app.jar

# Run the application
CMD ["java", "-jar", "app.jar"]

EXPOSE 8080
