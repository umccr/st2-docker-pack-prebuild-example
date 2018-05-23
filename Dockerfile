FROM stackstorm/stackstorm:2.6.0 AS base

COPY setup-pack-virtualenv.py /setup-pack-virtualenv.py


FROM base AS st2-ansible
RUN cd /opt/stackstorm/packs \
  && git clone https://github.com/umccr/stackstorm-ansible.git ansible \
  && apt-get install -y gcc libkrb5-dev \
  && /setup-pack-virtualenv.py --pack ansible

FROM base AS st2-arteria
RUN cd /opt/stackstorm/packs \
  && git clone https://github.com/umccr/arteria-packs.git arteria \
  && /setup-pack-virtualenv.py --pack arteria

FROM base AS st2-pcgr
RUN cd /opt/stackstorm/packs \
  && git clone --recurse-submodules https://github.com/umccr/stackstorm-pcgr.git pcgr \
  && /setup-pack-virtualenv.py --pack pcgr

FROM base AS st2-st2
RUN cd /opt/stackstorm/packs \
  && git clone https://github.com/StackStorm-Exchange/stackstorm-st2.git st2 \
  && /setup-pack-virtualenv.py --pack st2

FROM base AS st2-umccr
RUN cd /opt/stackstorm/packs \
  && git clone https://github.com/umccr/stackstorm-umccr.git umccr \
  && /setup-pack-virtualenv.py --pack umccr


FROM base
RUN /setup-pack-virtualenv.py --pack core \
  && /setup-pack-virtualenv.py --pack packs \
  && /setup-pack-virtualenv.py --pack linux \
  && /setup-pack-virtualenv.py --pack chatops


COPY --from=st2-ansible /opt/stackstorm/packs/ansible /opt/stackstorm/packs/ansible
COPY --from=st2-ansible /opt/stackstorm/virtualenvs/ansible /opt/stackstorm/virtualenvs/ansible

COPY --from=st2-arteria /opt/stackstorm/packs/arteria /opt/stackstorm/packs/arteria
COPY --from=st2-arteria /opt/stackstorm/virtualenvs/arteria /opt/stackstorm/virtualenvs/arteria

COPY --from=st2-pcgr /opt/stackstorm/packs/pcgr /opt/stackstorm/packs/pcgr
COPY --from=st2-pcgr /opt/stackstorm/virtualenvs/pcgr /opt/stackstorm/virtualenvs/pcgr

COPY --from=st2-st2 /opt/stackstorm/packs/st2 /opt/stackstorm/packs/st2
COPY --from=st2-st2 /opt/stackstorm/virtualenvs/st2 /opt/stackstorm/virtualenvs/st2

COPY --from=st2-umccr /opt/stackstorm/packs/umccr /opt/stackstorm/packs/umccr
COPY --from=st2-umccr /opt/stackstorm/virtualenvs/umccr /opt/stackstorm/virtualenvs/umccr


RUN apt-get update && apt-get install -y vim
