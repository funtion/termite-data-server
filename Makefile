DEMO_PATH = itm-data

all: $(DEMO_PATH)/10newsgroups $(DEMO_PATH)/15newsgroups $(DEMO_PATH)/20newsgroups
	./start_server.sh

setup:
	bin/setup_web2py.sh
	bin/setup.sh
	bin/setup_treetm.sh

$(DEMO_PATH)/corpus: setup
	bin/fetch_20newsgroups.sh $(DEMO_PATH)

$(DEMO_PATH)/10newsgroups: $(DEMO_PATH)/corpus
	bin/train_mallet.sh $(DEMO_PATH)/corpus $(DEMO_PATH)/10newsgroups 10
	bin/import_mallet.py 10newsgroups $(DEMO_PATH)/10newsgroups
	bin/import_corpus.py 10newsgroups --terms $(DEMO_PATH)/10newsgroups/corpus.mallet

$(DEMO_PATH)/15newsgroups: $(DEMO_PATH)/corpus
	bin/train_mallet.sh $(DEMO_PATH)/corpus $(DEMO_PATH)/15newsgroups 15
	bin/import_mallet.py 15newsgroups $(DEMO_PATH)/15newsgroups
	cp -r apps/10newsgroups/data/corpus apps/15newsgroups/data/corpus

$(DEMO_PATH)/20newsgroups: $(DEMO_PATH)/corpus
	bin/train_mallet.sh $(DEMO_PATH)/corpus $(DEMO_PATH)/20newsgroups 20
	bin/import_mallet.py 20newsgroups $(DEMO_PATH)/20newsgroups
	cp -r apps/10newsgroups/data/corpus apps/20newsgroups/data/corpus

clean:
	rm -rf $(DEMO_PATH)
