____________________________________________________________________________________


# Infraestructura y arquitectura de TI - 2024 Semestre I


___________________________________________________________________________________

# Proyecto Final ETL

#### Estado del proyecto: Completado pendiente por revisar

## Miembros y contactos
Lider del proyecto: Fabian Salazar Figueroa (https://github.com/alfa7g7)

Docente: Angela Villota (https://github.com/angievig)

|Equipo    |
|---------|
|Esteban Ordoñez (https://github.com/leoe21)
|Raul Echeverry (https://github.com/RaulEcheverryLopez)


## Objetivo
El objetivo es construir el proceso ETL utilizando Pentaho Data Integration (PDI) con el fin de obtener un archivo csv, realizando el proceso de extracción y transformación de los datos disponibles en la base de datos relacional BD Ames, en archivos csv y en MongoDB.

Limite hasta el día viernes 14 de junio de 2024.


### Tecnologías y metodos usados
* Pentaho (integración de bases de datos)
* Mongo DB (para sistema de base de datos NoSQL)
* ElephantSQL (para sistema de base de datos relacionales postgreSQL)
* Excel (para lectura de archivos csv y xlsx)



## Descripción del proyecto

### 1. Entendimiento de la data
#### 1.1. Base relacional:
Se descargan los archivos proveidos por la docente (<a href="https://drive.google.com/file/d/156iclNsLGvf6XYmuzhp1MAjiPY26EfL6/view">archivo script</a>  y <a href="https://drive.google.com/drive/folders/1bC-Ct8rAnUcJJzed9mELj156xJMKLPjZ">bases de datos</a>)  y se procede a crear una instacia en ElephantSQL bajo el nombre "FabianSF_DB". 
![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/fe5c9e1d-d489-4dfd-a138-9f41b1c842ca)

El primer archivo que se carga en el browser de Elephant es el script <strong>scriptAmesDB.sql</strong> y posterior se cargan las tablas: floordetail, amesdbtemp, saleproperty, mssubclass, mssubclass, mszoning y typequality.

![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/ebfb6d5c-b6b3-4906-a329-995ea46ed704)

Se identifica la tabla de hechos y tabla dimensiones mediante el esquema proveido por la docente:

![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/bf153919-6133-4e6c-a1de-7f49bc19d203)

La tabla de hechos es: <strong>mesdbtemp</strong> y el resto son dimensiones (loordetail; mssubclass; mszoning; saleproperty; typequality). 

Se realizan consultas para conocer cada tabla, algunos ejemplos basicos fueron:

select * from amesdbtemp;

select * from MSSubClass;

select * from MSZoning;

select * from TypeQuality;

select * from saleproperty;

select * from floordetail;

#Explorando conexion con MSZoning

SELECT DISTINCT "MS Zoning" 

FROM amesdbtemp

order by "MS Zoning" asc;

#Explorando conexion con MS SubClass

SELECT DISTINCT "MS SubClass" 

FROM amesdbtemp

order by "MS SubClass" asc;

Se complemento el entendimiento con el apoyo excel, copiando de cada tabla las primeras filas, el archivo excel se encuentra en https://github.com/MCD-Infrati/etlproject-infratech_24/blob/main/Postgre_understand/Muestreo_Bases.xlsx

En la base de Excel tambien se copió la base de muestra final para ir realizando el inventario de los campos.

![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/2ede6223-05f7-4daa-835b-be6651f76012)



#### 1.2. Base NOSQL:

PENDIENTE FABIAN


#### 1.3. Base CSV:

Con el uso de excel se procede a explorar el archivo <strong>AmesProperty.csv</strong>
![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/b19f1260-ee00-49c9-b939-ef5ad5809355)

### 2. Inventario de campos
Teniendo claro la infomración de cada fuente, se realiza el inventario final con respecto a la base resultado, como se muestra a continuación:

<img src="https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/46bff8b6-3f67-4368-8177-be654ec8b1aa" alt="image" width="400px">

Los campos en amarillo son aquellos a los que se debia relziar un calculo específico con el uso de consultas SQL en elephant para llevar dichos campos a la necesidad del ejercicio.

### 3. Carga de las bases en Pentaho Spoon

Se procede a cargar cada una de las bases en Pentaho:

<img src="https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/1aed317f-cd2b-4e7c-8dd7-fc26e5d84171" alt="image" width="400px">


La bases traidas desde Elephant, se cargan incluidas las consultas nesesarias y dando el orden y nombres identificados en el inventario de campos:
<br></br>
<strong>amesdbtemp en join con TypeQuality, MSZoning y MSSubClass y tranformación Gr Liv Area</strong>
<img src="https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/09760cc8-61c3-4930-9e78-9c1a5409a550" alt="image" width="500px">

<img src="https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/b3b9431e-2e3b-4c88-a326-fb366d17f071" alt="image" width="500px">


<br></br>

<strong>Transformación FullBath, HalfBath, Bedroom </strong>

Se deben calcular teniendo en cuenta que una propiedad puede tener varios pisos. En la tabla FloorDetail se encuentran los datos de cantidad de habitaciones, y baños, por piso para cada propiedad. La transformación consiste en calcular el total de baños FullBath, HalfBath, Bedroom.
<img src="https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/f4d13209-bd49-4bde-9e77-28e414430382" alt="image" width="500px">


<br></br>
<strong>Transformación Mo Sold,Yr Sold </strong>

En la tabla saleProperty se encuentra la fecha de venta y se requiere que en la salida esté solo mes (Mo Sold) y año de venta (Yr Sold).
<img src="https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/27a9c9b7-6737-4b17-83c7-06b3cd6b901f" alt="image" width="500px">


<br></br>
### 4. Transformaciones en Pentaho Spoon

<strong>Year Remod/Add</strong>

Contiene la fecha de remodelación, si no tiene, en vez de dejarlo en Null colocar la misma fecha de construcción Year Built.

![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/bdd26f6b-236d-4f99-a45f-b211b5abcc98)


<strong>Garage, pool, bsmt, misc</strong>
Al realizar el cargue de estos datos (garage, pool, bsmt, misc), si no se encuentran los datos, debe especificarse NA si es cualitativa y 0 si es numérica.

![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/f6205008-3f0c-40bb-b8b0-dce263d8182d)


<strong>Merge</strong>

El proceso ETL en Pentaho comienza con la base de datos Postgre_amesdbtemp, que se une inicialmente con floordetail y salesProperty. Para cada merge, se ordena previamente la columna PID en orden ascendente. Después de unir las bases de datos de PostgreSQL, se procede a hacer la unión con la base CSV, debidamente transformada y ordenada. Esta unión se realiza utilizando left outer join.

Finalizada y ordenada la unión con la base CSV, se comienza a unir con cada base de datos de MongoDB, transformada y ordenada: primero con la base bsmt, luego con la base garage, a continuación con la base misc y finalmente con la base pool. Cada unión se efectúa utilizando left outer join, garantizando que siempre se preserve la base madre.

Cada paso que se realiza, contiene una validación mediante una salida de excel dodne se revisaba cada resultado y asi tener control de cada paso relizado en la transformación.

![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/34daa725-8f1a-418b-beb6-0a643dfedf62)

Estos test de validación se guardan en la carpeta <a href="https://github.com/MCD-Infrati/etlproject-infratech_24/tree/main/Test_resultados">"Test_Resultados"</a>

![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/7cfce299-f5a4-43ee-a0a8-bd1acb884d32)



## Getting Started
Instructions for contributors
1. Clone this repo (for help see this [tutorial](https://help.github.com/articles/cloning-a-repository/)).
2. Raw Data is being kept [here](Repo folder containing raw data) within this repo.

    *If using offline data mention that and how contributors may obtain the data )*
    
3. Data processing/transformation scripts are being kept [here](Repo folder containing data processing scripts/notebooks)
4. etc...

*If your project is well underway and setup is fairly complicated (ie. requires installation of many packages) create another "setup.md" file and link to it here*  

5. Follow setup [instructions](Link to file)

## Featured Notebooks/Analysis/Deliverables
* [Notebook/Markdown/Slide Deck Title](link)
* [Notebook/Markdown/Slide DeckTitle](link)
* [Blog Post](link)


