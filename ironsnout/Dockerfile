FROM public.ecr.aws/nginx/nginx:alpine

COPY index.html /usr/share/nginx/html/
COPY logo.png /usr/share/nginx/html/
COPY html5game/ /usr/share/nginx/html/html5game/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
