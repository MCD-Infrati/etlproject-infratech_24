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

Se enlaza MongoDB con la <a href="https://docs.google.com/document/d/14NbPDg40BGuY0Y8KIH3CPpGZMAFUVUVd/edit">conexión proveida por la docente</a>, dando como resultado 4 colecciones: bsmt, garage, misc y pool:

![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/dae3eb1d-7ea5-4dd8-bb69-82382f906d62)

Se analizan los esquemas de cada una, para conocer el contenido de los documentos:

![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/3eecab6f-9791-405f-823f-1adc6d6559c1)


#### 1.3. Base CSV:

Con el uso de excel se procede a explorar el archivo <strong>AmesProperty.csv</strong>
![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/b19f1260-ee00-49c9-b939-ef5ad5809355)


### 2. Inventario de campos
Teniendo claro la información de cada fuente, se realiza el inventario final con respecto a la base resultado, como se muestra a continuación:

<img src="https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/46bff8b6-3f67-4368-8177-be654ec8b1aa" alt="image" width="400px">

Los campos en amarillo son aquellos a los que se debia realizar un cálculo específico con el uso de consultas SQL en elephant para llevar dichos campos a la necesidad del ejercicio.

### 3. Carga de las bases en Pentaho Spoon

Se procede a cargar cada una de las bases en Pentaho:

<img src="https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/1aed317f-cd2b-4e7c-8dd7-fc26e5d84171" alt="image" width="400px">


La bases traídas desde Elephant, se cargan incluidas las consultas nesesarias y dando el orden y nombres identificados en el inventario de campos:
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

Para realizar esta transformación se toma como insumo la categorizacion de variables que ofrece el input de entrada de Mongo y mediante un nodo de tipo "If null" se da la instrucción de esta transformación:

![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/26f54cce-6dc4-44ea-b1e8-23bd5b82680b)

Esto se implementa para cada base.

![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/f6205008-3f0c-40bb-b8b0-dce263d8182d)

Como nota importante, no se reemplaza o se tranforma los nulos en la columna PID dado que es la llave para los merge con las demás fuentes e incluso en pasos anteriores se verifica la inexistencia de nulos.


<strong>Merge</strong>

El proceso ETL en Pentaho comienza con la base de datos Postgre_amesdbtemp, que se une inicialmente con floordetail y salesProperty. Para cada merge, se ordena previamente la columna PID en orden ascendente. Después de unir las bases de datos de PostgreSQL, se procede a hacer la unión con la base CSV, debidamente transformada y ordenada. Esta unión se realiza utilizando left outer join.

Finalizada y ordenada la unión con la base CSV, se comienza a unir con cada base de datos de MongoDB, transformada y ordenada: primero con la base bsmt, luego con la base garage, a continuación con la base misc y finalmente con la base pool. Cada unión se efectúa utilizando left outer join, garantizando que siempre se preserve la base madre.

Cada paso que se realiza, contiene una validación mediante una salida de excel dodne se revisaba cada resultado y así tener control de cada paso realizado en la transformación.

![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/34daa725-8f1a-418b-beb6-0a643dfedf62)

Estos test de validación se guardan en la carpeta <a href="https://github.com/MCD-Infrati/etlproject-infratech_24/tree/main/Test_resultados">"Test_Resultados"</a>

![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/7cfce299-f5a4-43ee-a0a8-bd1acb884d32)

Las uniones de las 3 fuentes de los datos se concluye en el test número 12, a partir de este punto se relizan las transformaciones propias de la sección opcional para <strong>neighborhood, Lot Shape y finalmente Conditional</strong>, esta última aplicada a dos columnas del datasaet "Condition1" y "Condition2"

![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/b889b56f-d7ab-4d54-97f1-702c5b7d6388)

Las transformaciones de Condition1 y Condition2, a diferencia de Neighborhood y Lot Shape, presentaban la particularidad de que algunos registros ya venían con una estructura de código, mientras que otros contenían descripciones. Debido a la longitud de las cadenas de texto, no fue suficiente utilizar un simple sort para realizar los merges. Por lo tanto, se tuvo que aplicar reglas condicionales adicionales y realizar reemplazos de strings, ya que algunos merges no eran efectivos.

![image](https://github.com/MCD-Infrati/etlproject-infratech_24/assets/70969596/090fb1e6-eb88-4c31-81be-fa81bf6c5fb9)


<br></br>
### 5. Archivo final
Después de concluir todo el proceso, obtuvimos la base de datos con los parámetros exigidos por la docente, incluyendo el orden correcto de las columnas y las transformaciones pertinentes. El archivo resultante se puede observar en https://github.com/MCD-Infrati/etlproject-infratech_24/blob/main/Base_Resultado_Final.xlsx




## Lecciones Aprendidas
<ol>
<li><strong>Comprensión de los Datos</strong>: Es crucial realizar un entendimiento profundo de la data antes de su tratamiento y transformación. Esto permite comprender la realidad del problema o necesidad y diseñar un proceso ETL más eficiente y preciso.</li>
<li><strong>Ventajas de las Bases Relacionales</strong>: De todas las fuentes de datos, la base de datos relacional permitió una carga más eficiente, ya que al incrustar la consulta en Pentaho, se podían realizar transformaciones preliminares directamente en la base de datos. Esto redujo la carga de trabajo en el plano del aplicativo.</li>
<li><strong>Importancia de la Validación</strong>: Es fundamental tener nodos de validación con salidas de archivos para realizar pruebas de cada merge. Aunque existen nodos que permiten merges entre varias fuentes a la vez, para este caso de decidió ir uno por uno con su debido test lo cual ayudó mucho a hacer el control de calidad de la transformación</li>
<li><strong>Limitaciones del procesamiento de Pentaho para validaciones con salida excel</strong>: Los tests que generaban archivos CSV tenían que desactivarse porque Pentaho no generaba la cantidad completa de registros esperados, solo la mitad. Esto podría deberse a la capacidad limitada de procesamiento de Pentaho. Se dejó esta cuestión abierta para ser clarificada por la docente.</li>
<li><strong>Desafíos con Merges de Cadenas Largas</strong>: Al realizar merges con cadenas de texto largas, como en los casos de Condition1 y Condition2, el merge no fue tan efectivo. Esto llevó a la necesidad de utilizar métodos condicionales y reemplazos de strings. Esta experiencia resalta la importancia de usar valores numéricos o cadenas de texto cortas como claves primarias, siendo preferibles los valores numéricos.</li>
<li><strong>Trabajo en Equipo</strong>: El trabajo en equipo es crucial en este tipo de proyectos, ya que los conocimientos multidisciplinarios ayudan a encontrar soluciones y a generar un orden adecuado para el proceso ETL. La colaboración efectiva permitió abordar los desafíos de manera más eficiente y creativa.</li>
<li><strong>Automatización del Proceso ETL</strong>: La automatización del proceso ETL a través de herramientas como Pentaho es esencial para manejar grandes volúmenes de datos de manera eficiente. Permite reducir errores humanos y garantizar la consistencia y precisión de los datos transformados.</li>
<li><strong>Rutas locales de archivos para el trabajo conjunto</strong>: Fue importante tener en cuenta que cada vez que un miembro del equipo deseaba abrir el archivo y ejecutarlo desde su máquina local, era necesario actualizar las rutas de los archivos para que el flujo funcionara correctamente. En GitHub, dejábamos las rutas locales de cada miembro para que solo fuera necesario copiar y reemplazar la ruta en cada nodo donde se presentaba este requisito, los cuales eran los archivos de entrada y salida local.</li>
<li><strong>Documentación del Proceso</strong>: Mantener una documentación detallada de cada paso del proceso ETL es fundamental. Esto facilita la identificación de problemas, la reproducción de los procesos y el mantenimiento del sistema a largo plazo.</li>
<li><strong>Uso de herramientas en paralelo</strong>: A través de python en Visual Studio Code se pudo realizar una revisión rápida y eficiente de cada conjunto de datos obtenido en los diferentes pasos a modo de validación, resultando una valiosa aliada la extención <strong>Data Wrangler</strong>, la cual nos permitía examinar de manera completa cualquier conjunto obtenido en la pruebas sin necesidad dei implentar tanto código solo bastaba leer el conjunto de datos y cargarlo como un dataframe. Así la herramienta con solo visualizar el dataframe ya nos arrojaba análisis estadístico y distribuciones de los datos.</li>
    </ol>

Este ejercicio resultó interesante ya que permitió reforzar los conocimientos adquiridos en el módulo de Arquitectura e Infraestructura de TI. A través de la práctica, se pudo trabajar con diversos tipos de datos, desde la simplicidad de un archivo plano en CSV hasta la complejidad de bases de datos relacionales SQL y NoSQL. Esta experiencia práctica no solo consolidó nuestros conocimientos teóricos, sino que también nos permitió enfrentar y resolver retos reales en la transformación de datos, mejorando así nuestras habilidades en el manejo de diferentes estructuras y sistemas de bases de datos.
