PACKAGES := hypr waybar nvim shell

.PHONY: stow unstow restow
stow:
	@for p in $(PACKAGES); do stow -v --adopt $$p; done

unstow:
	@for p in $(PACKAGES); do stow -Dv $$p; done

restow:
	@for p in $(PACKAGES); do stow -Rv $$p; done

status:
	git status

save:
	git add -A && git commit -m "update dotfiles" && git push

