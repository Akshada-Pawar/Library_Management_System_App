FROM python:3
ADD library.py /
RUN pip install pyinstaller
CMD ["Python", "./library.py"]