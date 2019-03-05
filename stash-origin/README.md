Stash Origin Docker Image [![Build Status](https://travis-ci.org/opensciencegrid/docker-xcache.svg?branch=master)](https://travis-ci.org/opensciencegrid/docker-xcache)
=========================

The OSG operates the [StashCache data federation](https://opensciencegrid.org/docs/data/stashcache/overview/), which
provides organizations with a method to distribute their data in a scalable manner to thousands of jobs without needing
to pre-stage data across sites or operate their own scalable infrastructure.

[Stash Origins](https://opensciencegrid.org/docs/data/stashcache/install-origin/) keep the authoritative copy of an
organization's data.
Each origin is operated by the organization that wants to distribute its data within the StashCache federation.

This document describes how to configure, start, and verify a Stash Origin container.
