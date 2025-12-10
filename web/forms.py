# -*- coding: utf-8 -*-
from flask_wtf import FlaskForm
from wtforms import StringField, BooleanField, HiddenField, TextAreaField, SelectField, DecimalField, SelectMultipleField, DateTimeField, BooleanField
from wtforms.validators import DataRequired, Length, Regexp
from flask_uploads import UploadSet, IMAGES
from flask_wtf.file import FileField, FileAllowed, FileRequired

images = UploadSet('images', IMAGES)


class PageInfo():
    def __init__(self, pagename="", pagetask=""):
        self.pagename = pagename
        self.pagetask = pagetask


class SchoolForm(FlaskForm):
    id = HiddenField('id')
    name = StringField('School Name', validators=[Length(min=1, max=50)])
    area_id = SelectField(u'District', coerce=int)
    teachdesc = TextAreaField(u'Principal & Teachers Info')
    address = StringField('Address')
    schooltype_id = SelectField(u'School Type', coerce=int)
    website = StringField('Website')
    distinguish = TextAreaField(u'Teaching Features')
    leisure = TextAreaField(u'Extracurricular Activities')
    threashold = TextAreaField(u'Admission Requirements & Zones')
    partner = StringField('Partner School')
    artsource = StringField('Arts Enrollment')
    feedesc = StringField('Tuition Fee')
    longitude = DecimalField('Longitude', places=4)
    latitude = DecimalField('Latitude', places=4)
    feature_ids = SelectMultipleField(u'Teaching Features', coerce=int)
    image = FileField(
        'Upload Image', validators=[FileAllowed(['jpg', 'png'], 'Images only!')])


class InstitutionForm(FlaskForm):
    id = HiddenField('id')
    name = StringField('Brand Name', validators=[Length(min=1, max=50)])
    agespan_id = SelectField(u'Age Group', coerce=int)
    area_id = SelectField(u'District', coerce=int)
    address = StringField('Address')
    location = StringField('Campus Name')
    website = StringField('Website')
    telephone = StringField('Phone')
    feedesc = StringField('Tuition Fee')
    timeopen = DateTimeField('Opening Time', format='%H:%M')
    timeclose = DateTimeField('Closing Time', format='%H:%M')
    feetype_id = SelectField('Fee Type', coerce=int)
    longitude = DecimalField('Longitude', places=4)
    latitude = DecimalField('Latitude', places=4)
    # featuredesc = db.Column(db.String(200)) #Training specialties description
    feature_ids = SelectMultipleField(u'Training Focus', coerce=int)
    image = FileField(
        'Upload Image', validators=[FileAllowed(['jpg', 'png'], 'Images only!')])


class BulletinForm(FlaskForm):
    id = HiddenField('id')
    dt = DateTimeField('Published Date', format='%Y-%m-%d %H:%M:%S')
    title = StringField('Title')
    content = TextAreaField('Content')
    valid = BooleanField('Is Valid')
    source = StringField('Source')
    author = StringField('Author')
    image = FileField(
        'Upload Image', validators=[FileAllowed(['jpg', 'png'], 'Images only!')])


class AccountForm(FlaskForm):
    id = HiddenField('id')
    dtcreate = DateTimeField('Registration Date', format='%Y-%m-%d %H:%M:%S')
    username = StringField('Username')
    password = StringField('Password')
    name = StringField('Display Name')
    telephone = StringField('Phone Number')
    flag_telephone = BooleanField('Phone Verified')
    checkcode = StringField('Verification Code')
    source = StringField('Source')
