#Use this file with Microsoft NMake
THIRDPARTY_DIR=../../../ThirdParty

#Protobuf sources (.proto)
PROTO_DIR=../protobufs

#Java directories  
JAVASRC_DIR=src/java

GRAVJAVASRC_DIR=$(JAVASRC_DIR)/com/aphysci/gravity/

PROTOGENJAVA_DIR=$(GRAVJAVASRC_DIR)protobuf/

#Generated Java source dir
SWIGGENJAVA_DIR=$(GRAVJAVASRC_DIR)swig/

#Java Output dirs
JAVA_BUILD_DIR=build
GRAVJAVACLASS_DIR=$(JAVA_BUILD_DIR)/com/aphysci/gravity/
PROTOJAVACLASS_DIR=$(GRAVJAVACLASS_DIR)protobuf/
SWIGJAVACLASS_DIR=$(GRAVJAVACLASS_DIR)swig/

#Tools
PROTOC=..\..\..\ThirdParty\bin\protoc

#Naming
JAR_NAME=gravity.jar

#Visual Studio
CLASSPATH_SEP=;

MY_CLASSPATH="$(THIRDPARTY_DIR)/lib/protobuf-java-2.4.1.jar$(CLASSPATH_SEP)build$(CLASSPATH_SEP)."

#Source/Object/Dependancies
CLASSES=$(GRAVJAVACLASS_DIR)/GravityDataProduct.class $(GRAVJAVACLASS_DIR)/GravityHeartbeatListener.class $(GRAVJAVACLASS_DIR)/GravityRequestor.class $(GRAVJAVACLASS_DIR)/GravityServiceProvider.class $(GRAVJAVACLASS_DIR)/GravitySubscriber.class $(GRAVJAVACLASS_DIR)/Logger.class

GEN_CLASSES=$(SWIGJAVACLASS_DIR)/CPPGravityHeartbeatListener.class $(SWIGJAVACLASS_DIR)/CPPGravityLogger.class $(SWIGJAVACLASS_DIR)/CPPGravityRequestor.class $(SWIGJAVACLASS_DIR)/CPPGravityServiceProvider.class $(SWIGJAVACLASS_DIR)/CPPGravitySubscriber.class $(SWIGJAVACLASS_DIR)/GravityNode.class $(SWIGJAVACLASS_DIR)/GravityReturnCode.class $(SWIGJAVACLASS_DIR)/Log.class $(SWIGJAVACLASS_DIR)/gravity.class $(SWIGJAVACLASS_DIR)/gravityConstants.class $(SWIGJAVACLASS_DIR)/gravityJNI.class

#Protobuf Source/Generated Java/Objects
PROTO_SRC=$(PROTO_DIR)/GravityDataProductPB.proto

PROTO_JAVA=$(PROTOGENJAVA_DIR)GravityDataProductContainer.java

PROTO_CLASS=$(PROTOJAVACLASS_DIR)GravityDataProductContainer.class

.PRECIOUS: %.java $(PROTO_JAVA)

.SUFFIXES: .java

all: $(JAR_NAME)

$(PROTO_JAVA): $(PROTO_SRC)
	@echo $**
	$(PROTOC) --proto_path=$(PROTO_DIR) --java_out=$(JAVASRC_DIR) $**

#protobuf java -> class
#{src/java/com/aphysci/gravity/protobuf/}.java{build/}.class::
$(PROTO_CLASS): $(PROTO_JAVA)
	@echo $**
	@javac -d $(JAVA_BUILD_DIR) -cp $(MY_CLASSPATH) $**

#Generated java -> class
{$(SWIGGENJAVA_DIR)}.java{$(SWIGJAVACLASS_DIR)}.class:
	@echo $<
	@javac -d $(JAVA_BUILD_DIR) -cp $(MY_CLASSPATH) -sourcepath $(JAVASRC_DIR) $<

#Static java -> class
{$(GRAVJAVASRC_DIR)}.java{$(GRAVJAVACLASS_DIR)}.class:
	@echo $<
	@javac -d $(JAVA_BUILD_DIR) -cp $(MY_CLASSPATH) -sourcepath $(JAVASRC_DIR) $<
	
#Swig should have already run
#classes -> jar
$(JAR_NAME): $(PROTO_CLASS) $(CLASSES) $(GEN_CLASSES)
	jar cf $(JAR_NAME) -C $(JAVA_BUILD_DIR) .

clean:
	del /q src\java\com\aphysci\gravity\protobuf\GravityDataProductContainer.java
	del $(JAR_NAME)
	rmdir /q /s $(JAVA_BUILD_DIR)\com 	