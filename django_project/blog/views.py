from django.shortcuts import render
from django.http import HttpResponse

posts = [
    {
        'author' : 'Frantisek Malinka',
        'title' : 'Blog post 1',
        'content' : 'First post content',
        'date_posted' : 'January 14, 2022'
    },
    {
        'author' : 'Joe Malinka',
        'title' : 'Blog post 2',
        'content' : 'Second post content',
        'date_posted' : 'January 15, 2022'
    }
]

# Create your views here.
def home(request):
    #return HttpResponse('<h1>Blog Home</h1>')
    context = {
        'posts' : posts
    }
    return render(request, 'blog/home.html', context)

def about(request):
    #return HttpResponse('<h1>Blog About</h1>')
    return render(request, 'blog/about.html', {'title' : 'About'})