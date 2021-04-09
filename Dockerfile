FROM python:3.9
ENV PYTHONUNBUFFERED=1
USER root
RUN apt-get update -y
RUN apt-get install -y locales
#RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN dpkg-reconfigure locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen
WORKDIR /code
#COPY requirements.txt /code/
#RUN pip freeze > requirements.txt
COPY . /code/

RUN pip install pip install -U cartridge
RUN pip install -r requirements.txt

#RUN python manage.py createdb --noinput
CMD ["python", "manage.py", "createdb", "--noinput"]

#Notas importantes ...
#Tenemos que esperar que se creen los contenedores para poder referenciarlos por medio de su nombre
#Por ejemplo la base de datos mysql para usar "dbmysql" como host se tendria que enviar por CMD los comandos 
#dado que primero se crean e inician los contenedores, no podemos hace rtodo al mismo tiempo, por ende temas como las 
#migraciones se debe enviar por CMD lo cual se ejecuta una vez se terminen de crear todos los contenedores

#con respecto a los erroes de cartridge, simplemente teniamos que cambiar el idioma de linux a "en_US.UTF-8" para que 
#no se generaran errores con los tipos de datos de mysql, linux no viene por defecto en "en_US.UTF-8", por ello se 
#instala las localidades, luego se descomenta el idioma que deseamos y se reseta las localidades para tenerlo disponible
#en el codigo simplemente se agrega la localidad con la que se va ha trabajar com import locale.

# on second step use another core image
#FROM nginx
# copy files builded on previous step
#COPY ./deploy/ /etc/nginx/conf.d
#COPY --from=builder /code/ usr/share/nginx/html

