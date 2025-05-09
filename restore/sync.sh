#!/bin/bash
docker cp strapi:/opt/app/src ./admin/strapi/src
docker cp strapi:/opt/app/config ./admin/strapi/config
docker cp strapi:/opt/app/public/uploads ./admin/strapi/public/uploads