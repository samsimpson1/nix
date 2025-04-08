#!/usr/bin/env nix-shell
#!nix-shell -i python -p python312 gh

import argparse
from subprocess import check_output, check_call, call
from pathlib import Path
from shutil import rmtree
from json import loads

TEMPLATE = Path.home() / "issues" / "template.md"

def get_labels():
  gh_res = check_output("gh label -R alphagov/govuk-infrastructure list --json name,description", shell=True).decode("utf-8")
  labels = loads(gh_res)
  return labels

def render_labels():
  labels = get_labels()
  labels_str = ""
  for label in labels:
    labels_str += label["name"]
    if "description" in label and label["description"] != "":
     labels_str += ": " + label["description"]
    labels_str += "\n"
  return labels_str

def parse_labels(path):
  labels_f = open(path, "r")
  chosen_labels = []
  for label_l in labels_f.readlines():
    if label_l.startswith("X "):
      label_name = label_l.split(":")[0][2:].strip()
      chosen_labels.append(label_name)
  return chosen_labels

def write_labels_to(path):
  labels = render_labels()
  with open(path, "w") as f:
    f.write(labels)

def get_template():
  with open(TEMPLATE, "r") as f:
    return f.read()

def write_template_to(body_path):
  t = get_template()
  with open(body_path, "w") as f:
    f.write(t)

def ensure_issues_dir():
  home = Path.home()
  issues_path = home / "issues"
  issues_path.mkdir(exist_ok=True)

def issue_path(name):
  home = Path.home()
  return home / "issues" / name

def delete_issue(args):
  path = issue_path(args.issue_name)
  rmtree(path)

def create_issue(args):
  path = issue_path(args.issue_name)
  if path.exists():
    ok = input(f"Issue directory '{path}' already exists. Delete contents? [Y/n] ")
    if ok.lower() == "y":
      delete_issue(args)
    else:
      exit(0)
  path.mkdir(mode=0o700)
  (path / "title").touch(mode=0o600)
  write_template_to(path / "body.md")
  write_labels_to(path / "labels")

  call(f"nvim {path}", shell=True)

def submit_issue(args):
  path = issue_path(args.issue_name)
  labels = ",".join(parse_labels(path / "labels"))

  title = open(path / "title", "r").read().strip()

  body_path = path / "body.md"

  gh_cmd = [
    "gh", "issue", "create",
    "-R", "alphagov/govuk-infrastructure",
    "-F", str(body_path),
    "--title", title
  ]
  if len(labels) > 0:
    gh_cmd += ["--label", labels]
  print("About to run the following command:")
  print("  " + " ".join(gh_cmd))
  ok = input("Ok? [Y/n] ")
  if ok.lower() != "y":
    exit(0)
  check_call(gh_cmd)

parser = argparse.ArgumentParser(prog="IssueMaker")
subs = parser.add_subparsers()

parser.add_argument("issue_name")

parser_create = subs.add_parser("create")
parser_create.set_defaults(func=create_issue)

subs.add_parser("delete").set_defaults(func=delete_issue)

subs.add_parser("submit").set_defaults(func=submit_issue)

args = parser.parse_args()

ensure_issues_dir()

if not TEMPLATE.exists():
  print("template.md does not exist")
  exit(1)

args.func(args)
