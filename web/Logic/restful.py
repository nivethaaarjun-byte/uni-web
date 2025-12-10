# -*- coding: utf-8 -*-
import os

# Use environment variable or construct from request context
# In production (Render), this will use the deployed URL
# In development, it will use localhost
ROOT_DOMAIN = os.environ.get('APP_URL', 'http://127.0.0.1:5010')
ROOT_RESTFUL = ROOT_DOMAIN + '/bd/api/v1.0'

RESTFUL_SCHOOL = ROOT_RESTFUL + '/school'
RESTFUL_INSTITUTION = ROOT_RESTFUL + '/institution'
RESTFUL_BULLETIN = ROOT_RESTFUL + '/bulletin'
RESTFUL_ACCOUNT = ROOT_RESTFUL + '/account'
RESTFUL_ACCOUNTBACK = ROOT_RESTFUL + '/back/account'

ITEM_TOTAL_PAGES = 'total_pages'
ITEM_PAGE = 'page'
ITEM_OBJECTS = 'objects'
ITEM_NUM_RESULTS = 'num_results'

ITEM_BULLETINIMAGES = 'bulletinimages'
ITEM_INSTITUTIONIMAGES = 'institutionimages'
ITEM_SCHOOLIMAGES = 'schoolimages'
ITEM_FILE = 'file'

ITEM_ID = 'id'
ITEM_NAME = 'name'

ITEM_CODE = 'code'
ITEM_OS = 'os'
ITEM_CHECKCODE = 'checkcode'
ITEM_FLAG_TELEPHONE = 'flag_telephone'
ITEM_TELEPHONE = 'telephone'
ITEM_USERNAME = 'username'
ITEM_SOURCE = 'source'
ITEM_DTCREATE = 'dtcreate'

import json
import requests
import urllib


def PostAccount(body):
    headers = {'Content-type': 'application/json'}
    data = json.dumps(body)
    return json.loads(
        requests.post(
            '%s' % (RESTFUL_ACCOUNTBACK), data=data, headers=headers).text)


def GetSchools(page, name=None):
    """Get schools directly from database instead of making HTTP requests"""
    from DB import orm
    from flask import url_for
    
    per_page = 7  # Same as API default
    
    if name is None:
        query = orm.School.query
    else:
        query = orm.School.query.filter(orm.School.name.like('%%%s%%' % name))
    
    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    
    # Format response to match API structure
    objects = []
    for school in pagination.items:
        school_dict = {
            ITEM_ID: school.id,
            ITEM_NAME: school.name,
            'area_id': school.area_id,
            'teachdesc': school.teachdesc,
            'address': school.address,
            'schooltype_id': school.schooltype_id,
            'website': school.website,
            'distinguish': school.distinguish,
            'leisure': school.leisure,
            'threashold': school.threashold,
            'partner': school.partner,
            'artsource': school.artsource,
            'feedesc': school.feedesc,
            'longitude': school.longitude,
            'latitude': school.latitude,
            ITEM_SCHOOLIMAGES: [{'id': img.id, 'file': img.file} for img in school.schoolimages]
        }
        objects.append(school_dict)
    
    return {
        ITEM_OBJECTS: objects,
        ITEM_PAGE: page,
        ITEM_TOTAL_PAGES: pagination.pages,
        ITEM_NUM_RESULTS: pagination.total
    }


def GetInstitutions(page, name=None):
    """Get institutions directly from database instead of making HTTP requests"""
    from DB import orm
    
    per_page = 10  # Default per page
    
    if name is None:
        query = orm.Institution.query
    else:
        query = orm.Institution.query.filter(orm.Institution.name.like('%%%s%%' % name))
    
    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    
    objects = []
    for institution in pagination.items:
        inst_dict = {
            ITEM_ID: institution.id,
            ITEM_NAME: institution.name,
            'agespan_id': institution.agespan_id,
            'area_id': institution.area_id,
            'address': institution.address,
            'location': institution.location,
            'website': institution.website,
            'telephone': institution.telephone,
            'feedesc': institution.feedesc,
            'timeopen': institution.timeopen.isoformat() if institution.timeopen else None,
            'timeclose': institution.timeclose.isoformat() if institution.timeclose else None,
            'feetype_id': institution.feetype_id,
            'longitude': institution.longitude,
            'latitude': institution.latitude,
            ITEM_INSTITUTIONIMAGES: [{'id': img.id, 'file': img.file} for img in institution.institutionimages]
        }
        objects.append(inst_dict)
    
    return {
        ITEM_OBJECTS: objects,
        ITEM_PAGE: page,
        ITEM_TOTAL_PAGES: pagination.pages,
        ITEM_NUM_RESULTS: pagination.total
    }


def GetBulletins(page, title=None):
    """Get bulletins directly from database instead of making HTTP requests"""
    from DB import orm
    
    per_page = 10  # Default per page
    
    if title is None:
        query = orm.Bulletin.query
    else:
        query = orm.Bulletin.query.filter(orm.Bulletin.title.like('%%%s%%' % title))
    
    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    
    objects = []
    for bulletin in pagination.items:
        bull_dict = {
            ITEM_ID: bulletin.id,
            'dt': bulletin.dt.isoformat() if bulletin.dt else None,
            'title': bulletin.title,
            'content': bulletin.content,
            'valid': bulletin.valid,
            'source': bulletin.source,
            'author': bulletin.author,
            ITEM_BULLETINIMAGES: [{'id': img.id, 'file': img.file} for img in bulletin.bulletinimages]
        }
        objects.append(bull_dict)
    
    return {
        ITEM_OBJECTS: objects,
        ITEM_PAGE: page,
        ITEM_TOTAL_PAGES: pagination.pages,
        ITEM_NUM_RESULTS: pagination.total
    }


def GetPagingFromResult(result):
    total_pages = int(result[ITEM_TOTAL_PAGES])
    page = int(result[ITEM_PAGE])
    page_from = max(1, page - 5)
    page_to = min(total_pages, page + 5)
    return {
        'total_pages': total_pages,
        'page': page,
        'page_from': page_from,
        'page_to': page_to
    }


def GetAccounts(page, title=None):
    """Get accounts directly from database instead of making HTTP requests"""
    from DB import orm
    from sqlalchemy import or_
    
    per_page = 10  # Default per page
    
    if title is None:
        query = orm.Account.query
    else:
        query = orm.Account.query.filter(
            or_(
                orm.Account.username.like('%%%s%%' % title),
                orm.Account.name.like('%%%s%%' % title),
                orm.Account.telephone.like('%%%s%%' % title)
            )
        )
    
    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    
    objects = []
    for account in pagination.items:
        acc_dict = {
            ITEM_ID: account.id,
            ITEM_USERNAME: account.username,
            ITEM_NAME: account.name,
            ITEM_TELEPHONE: account.telephone,
            'role': account.role,
            ITEM_FLAG_TELEPHONE: account.flag_telephone,
            ITEM_SOURCE: account.source,
            ITEM_DTCREATE: account.dtcreate.isoformat() if account.dtcreate else None
        }
        objects.append(acc_dict)
    
    return {
        ITEM_OBJECTS: objects,
        ITEM_PAGE: page,
        ITEM_TOTAL_PAGES: pagination.pages,
        ITEM_NUM_RESULTS: pagination.total
    }
