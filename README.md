## Contribuer

Chaque nouvelle fonctionnalité ou résolution de bug doit être réalisée dans une branche dédiée.

Voici la démarche à suivre :

- S'assurer que master local est à jour : `git checkout master && git pull origin master --rebase`
- Créer une nouvelle branche : `git checkout -b <feature-branch>` (sans les `<>`)
- Après modifications, commiter la sélection : `git add -A && git commit`
- Puis pousser les refs sur le remote : `git push origin <feature-branch>`

Pour review une branche :

- S'assurer que master local est à jour : `git checkout master && git pull origin master --rebase`
- Mettre à jour les références locales vers les branches du remote : `git fetch`
- Créer une copie locale de la branche de feature : `git checkout -b <feature-branch> origin/<feature-branch>`
- S'assurer que la branche de feature est synchronisée sur master, et résoudre les éventuels conflits : `git rebase master`
- Quand tout est validé, merger la branche dans master : `git checkout master && git merge <feature-branch>`
- Puis pousser les refs sur le remote : `git push origin master`
