# Host Langflow

This repo contains a Dockerfile to help you host Langflow with any hosting provider that supports Docker.

## Usage

The directory structure here helps you deploy to specific targets. Follow this guidance:

- The `bm` directory is for bare metal deployments where you have root access to an actual machine.
- The `fc` directory is for [Flightcontrol](https://flightcontrol.dev), which requires web services to bind to localhost and not a loopback address (0.0.0.0).
- The root is a typical Dockerfile for any standard hosting provider like [Fly.io](https://fly.io) or [Render](https://render.com).
