from django.shortcuts import render
from django.http import HttpResponse

def hello_view(request):
    return HttpResponse("Witaj w OKD 18.12.2023 9:10:00")